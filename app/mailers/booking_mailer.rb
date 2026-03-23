class BookingMailer < ApplicationMailer
    default from: "no-reply@myapp.com"
    def booking_confirmed(booking)
        @booking = booking
        @user = booking.attendee
        @event = booking.event

        mail( to: @user.email, subject: "Woohoo your Booking is confirmed !!")
    end
    
    def booking_cancelled(booking)
        @booking = booking
        @user = booking.attendee
        @event = booking.event

        mail( to: @user.email, subject: "Your Booking is cancelled !!")
    end


    layout "mailer"

end
