module Services
  # Example service which generic handler
  class ServiceWithGenericHandler
    def handle(num)
      puts "ServiceWithGenericHandler Recived message #{num}"
      num + num
    end
  end
end
