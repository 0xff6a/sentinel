require 'thread'
require 'monitor'
require 'net/http'

require_relative '../tools/geolocator'

### SPIKE FOR MULTITHREADED IP LOCATION

# this would replace the Analyzer::Geographical function

# module AnalyticEngines
  # class Geographical
    # get a set of paginate es records
    # for each recordset create a new thread
    # in each thread geolocate the IPs and add to results array
    # when each thread has completed return the results array
    # alongside results array return meta data

    # Our set of records / ips
    ips = [
      "178.255.153.2",
      "199.87.228.66",
      "184.75.209.18",
      "85.17.156.11",
      "94.46.240.121",
      "94.247.174.83",
      "108.62.115.226",
      "188.138.124.110",
      "72.46.130.42"
    ]

    # Set a finite number of simultaneous worker threads that can run
    thread_count = 10

    # Create an array to keep track of threads
    threads = Array.new(thread_count)

    # Create a results array
    results = []

    # Create a mutex for the shared results array
    results_mutex = Mutex.new

    # Create a work queue for the producer to give work to the consumer
    work_queue = SizedQueue.new(thread_count)

    # Add a monitor so we can notify when a thread finishes and we can schedule a new one
    threads.extend(MonitorMixin)

    # Add a condition variable on the monitored array to tell the consumer to check the thread array
    threads_available = threads.new_cond

    # Add a variable to tell the consumer that we are done producing work
    sysexit = false

    consumer_thread = Thread.new do
      loop do
        # Stop looping when the producer is finished producing work
        break if sysexit && work_queue.length == 0
        found_index = nil

        # The MonitorMixin requires us to obtain a lock on the threads array in case
        # a different thread may try to make changes to it.
        threads.synchronize do
          # First, wait on an available spot in the threads array.  This fires every
          # time a signal is sent to the "threads_available" variable
          threads_available.wait_while do
            threads.select { |thread| 
              thread.nil? || thread.status == false  || thread["finished"].nil? == false
            }.length == 0
          end

          # Once an available spot is found, get the index of that spot so we may
          # use it for the new thread
          found_index = threads.rindex do |thread| 
            thread.nil? || thread.status == false || thread["finished"].nil? == false 
          end
        end

        # Get a new unit of work from the work queue
        ip = work_queue.pop

        # Pass the ip variable to the new thread so it can use it as a parameter to go
        # get the location
        threads[found_index] = Thread.new(ip) do
          # Add results to the array
          results_mutex.synchronize do
            results << Tools::Geolocator.locate(ip)
          end
          # When this thread is finished, mark it as such so the consumer knows it is a
          # free spot in the array.
          Thread.current["finished"] = true

          # Tell the consumer to check the thread array
          threads.synchronize do
            threads_available.signal
          end
        end
      end
    end

    producer_thread = Thread.new do
      # For each ip we need to geolocate..
      ips.each do |ip|
        # Put the ip on the work queue
        work_queue << ip

        # Tell the consumer to check the thread array so it can attempt to schedule the
        # next job if a free spot exists.
        threads.synchronize do
          threads_available.signal
        end
      end
      # Tell the consumer that we are finished calling geolocation api
      sysexit = true
    end

    # Join on both the producer and consumer threads so the main thread doesn't exit while
    # they are doing work.
    producer_thread.join
    consumer_thread.join

    # Join on the child processes to allow them to finish (if any are left)
    threads.each do |thread|
        thread.join unless thread.nil?
    end

    puts results.inspect
    puts "#{results.length} IPs returned."
    puts "DONE!"
  # end
# end