module Services
  class ServiceWithBespokeHandler
    def method1(message)
      puts "ServiceWithBespokeHandler Recived message #{message} on message1 receiver"
    end

    def method2(message)
      puts "ServiceWithBespokeHandler Recived message #{message} on message2 receiver"
    end

    def method3(message)
      puts "ServiceWithBespokeHandler Recived message #{message} on message3 receiver"
    end
  end
end
