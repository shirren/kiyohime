module Services
  class ServiceWithGenericHandler
    def handle(message)
      puts "ServiceWithGenericHandler Recived message #{message}"
      true
    end
  end
end
