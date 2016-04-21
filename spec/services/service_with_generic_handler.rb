module Services
  class ServiceWithGenericHandler
    def handle(message)
      puts "ServiceWithGenericHandler Recived message #{message}"
    end
  end
end
