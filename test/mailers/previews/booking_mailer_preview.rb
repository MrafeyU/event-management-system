# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview
    def booking_confirmed
        BookingMailer.booking_confirmed(@booking)
    end
    def booking_cancelled
        BookingMailer.booking_cancelled(@booking)
    end
    
end
