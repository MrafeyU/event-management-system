# Event Management System

A comprehensive web application that enables users to browse events, book seats, and manage event bookings. Event organizers can create and manage events, while administrators have full platform oversight.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Database Schema](#database-schema)
- [User Roles & Permissions](#user-roles--permissions)
- [API Routes](#api-routes)
- [Testing](#testing)
- [Email Notifications](#email-notifications)
- [Troubleshooting](#troubleshooting)

## Project Overview

The Event Management System is a full-featured Ruby on Rails application designed to facilitate event discovery, booking, and management. It supports multiple user roles with different capabilities, implements secure authentication, and handles concurrent booking operations to prevent overbooking.

### Core Objectives

- Enable attendees to browse and book event seats
- Allow organizers to create and manage their events
- Provide administrators with complete platform oversight
- Ensure secure, role-based access control
- Handle concurrent bookings without race conditions
- Send email notifications for booking confirmations and cancellations

## Features

### User Authentication

- Registration with name, email, and password
- Secure login/logout using Devise
- Password encryption with bcrypt
- Role assignment during signup (Admin, Organizer, or Attendee)

### Event Management

- **Browse Events**: View all upcoming events with search and filtering
- **Create Events**: Organizers can create events with details:
  - Title, description, location
  - Event date & time
  - Total seats and ticket price
- **Edit/Delete**: Organizers can manage their own events
- **Event Images**: Upload images for events (bonus feature)

### Booking System

- Book seats for upcoming events
- View booking history (upcoming and past)
- Cancel bookings with automatic seat release
- Prevent overbooking with database-level concurrency control
- Email notifications for confirmation and cancellation

### Dashboards

- **Attendee Dashboard**: View upcoming/past bookings and booking status
- **Organizer Dashboard**: Manage events, view bookings, and analytics
- **Admin Dashboard**: Overview of all users, events, and bookings with management actions

### Authorization

- Role-based access control using Pundit
- Attendees cannot create/edit events
- Organizers cannot modify other organizers' events
- Admins have full platform access

## Tech Stack

- **Ruby Version**: 3.3.0+
- **Rails Version**: 8.0+
- **Database**: SQLite (development), PostgreSQL (production)
- **Authentication**: Devise
- **Authorization**: Pundit
- **Frontend**: HTML/ERB, Bootstrap CSS, Turbo Frames
- **Jobs**: Sidekiq (async job processing)
- **Email**: ActionMailer with Letter Opener (development)
- **Testing**: RSpec, Factory Bot
- **Additional Gems**:
  - Kaminari (pagination)
  - Brakeman (security scanning)
  - RuboCop (code linting)
  - Bundler Audit (dependency vulnerability scanning)

## Prerequisites

Before setting up the project, ensure you have:

- **Ruby 3.3.0+** ([Install Ruby](https://www.ruby-lang.org/en/documentation/installation/))
- **Rails 8.0+** (installed via gem)
- **Bundler** (gem package manager)
- **Node.js 18.0+** (for asset compilation)
- **SQLite3** (for development)
- **Git** (for version control)

Verify installations:

```bash
ruby --version
rails --version
node --version
git --version
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd event-management-system
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies
npm install
```

### 3. Configure Environment Variables

Create a `.env` file in the project root (or use Rails credentials):

```bash
# For development, you can use the default values
# Rails will handle most defaults automatically
```

### 4. Setup Database

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Load seed data (optional - creates sample data)
rails db:seed
```

### 5. Compile Assets

```bash
# Build assets for development
./bin/importmap install

# Or use the provided bin script
./bin/dev  # Starts both Rails server and asset watcher
```

### 6. Start the Server

```bash
# Option 1: Using the dev script (recommended)
./bin/dev

# Option 2: Manual Rails server
rails server

# Server will be available at http://localhost:3000
```

### 7. Create Admin User (Optional)

```bash
rails console

# In the Rails console, create an admin:
Admin.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123"
)
```

### 8. Access the Application

- **Homepage**: `http://localhost:3000`
- **Sign Up**: `http://localhost:3000/users/sign_up`
- **Sign In**: `http://localhost:3000/users/sign_in`

## Project Structure

```
event-management-system/
├── app/
│   ├── controllers/              # Request handlers
│   │   ├── application_controller.rb
│   │   ├── events_controller.rb
│   │   ├── bookings_controller.rb
│   │   └── admin/                # Admin namespace
│   ├── models/                   # Data models
│   │   ├── user.rb
│   │   ├── event.rb
│   │   ├── booking.rb
│   │   ├── admin.rb
│   │   ├── organizer.rb
│   │   └── attendee.rb
│   ├── views/                    # View templates
│   │   ├── events/
│   │   ├── bookings/
│   │   ├── admin/
│   │   ├── organizer/
│   │   └── attendee/
│   ├── mailers/                  # Email templates & logic
│   │   └── booking_mailer.rb
│   ├── jobs/                     # Background jobs
│   ├── policies/                 # Authorization policies
│   │   ├── application_policy.rb
│   │   ├── event_policy.rb
│   │   └── booking_policy.rb
│   └── helpers/                  # View helpers
├── config/
│   ├── routes.rb                 # Route definitions
│   ├── database.yml              # Database config
│   ├── credentials.yml.enc       # Encrypted secrets
│   └── environments/             # Environment-specific configs
├── db/
│   ├── schema.rb                 # Current database schema
│   ├── seeds.rb                  # Sample data
│   └── migrate/                  # Database migrations
├── spec/                         # Test files
│   ├── models/
│   ├── requests/
│   ├── factories/
│   └── rails_helper.rb
├── public/                       # Static files
├── Gemfile                       # Gem dependencies
├── Rakefile                      # Rake tasks
├── config.ru                     # Rack config
└── README.md                     # This file
```

## Architecture

### MVC Pattern

The application follows Rails MVC (Model-View-Controller) architecture:

- **Models**: `User`, `Event`, `Booking`, and role-specific subclasses (`Admin`, `Organizer`, `Attendee`)
- **Controllers**: Handle HTTP requests and coordinate between models and views
- **Views**: Render HTML templates with ERB, using Bootstrap for styling

### Authentication & Authorization

- **Devise**: Handles user registration, login, and session management
- **Pundit**: Policy-based authorization system that checks user permissions before allowing actions
- **Roles**: Three STI (Single Table Inheritance) subclasses of User:
  - `Admin`: Full platform access
  - `Organizer`: Can create/manage events
  - `Attendee`: Can browse/book events

### Request Flow

```
Browser Request
    ↓
Routes (config/routes.rb) - Determines controller & action
    ↓
Controller - Authenticates user with Devise
    ↓
Authorization Policy - Checks Pundit policies
    ↓
Model Logic - Business logic with validations
    ↓
Database Transaction - ACID compliance
    ↓
View Rendering - Sends response
    ↓
Response to Browser
```

### Concurrency Handling

The booking system prevents race conditions through:

- **Database-level locking**: Uses pessimistic locking (`lock!`) during transaction
- **Atomic transactions**: Entire booking operation in single database transaction
- **Validation**: Real-time seat availability checks

```ruby
# Example from BookingsController
Event.transaction do
  event.lock!  # Lock the event record
  if event.available_seats >= quantity
    # Create booking
  end
end
```

## Database Schema

### Users Table

```
users
├── id: integer
├── email: string (unique)
├── encrypted_password: string
├── name: string
├── type: string (STI - Admin, Organizer, Attendee)
├── avatar: string (Active Storage)
├── created_at: datetime
└── updated_at: datetime
```

### Events Table

```
events
├── id: integer
├── title: string
├── description: text
├── location: string
├── event_date: datetime
├── total_seats: integer
├── available_seats: integer
├── ticket_price: decimal
├── organizer_id: integer (FK to users)
├── created_at: datetime
└── updated_at: datetime
```

### Bookings Table

```
bookings
├── id: integer
├── user_id: integer (FK to users - attendee)
├── event_id: integer (FK to events)
├── number_of_seats: integer
├── status: string (confirmed, cancelled)
├── booking_timestamp: datetime
├── created_at: datetime
└── updated_at: datetime
```

## User Roles & Permissions

### Admin

- View all users, events, and bookings
- Delete/suspend users
- Delete/edit any event
- Cancel any booking
- Access admin dashboard

### Organizer

- Create events
- Edit/delete their own events
- View bookings for their events
- See event statistics and revenue
- Access organizer dashboard

### Attendee

- Browse upcoming events
- Search and filter events
- Book seats for available events
- View upcoming and past bookings
- Cancel their own bookings
- Access attendee dashboard

## API Routes

### Events

```
GET  /role/events              # List all events with search/filter
GET  /role/events/:id          # Show event details
POST /role/events              # Create event (Organizers only)
GET  /role/events/:id/edit     # Edit form (Organizers only)
PATCH /role/events/:id         # Update event (Organizers only)
DELETE /role/events/:id        # Delete event (Organizers only)
```

### Bookings

```
GET  /role/bookings            # List user's bookings
POST /role/events/:event_id/bookings  # Create booking
GET  /role/bookings/:id        # Show booking details
PATCH /role/bookings/:id       # Update booking
DELETE /role/bookings/:id      # Cancel booking
PATCH /role/bookings/:id/cancel # Cancel with custom logic
```

### Admin Routes

```
GET  /admin                    # Admin dashboard
GET  /admin/users              # List all users
DELETE /admin/users/:id        # Delete user
PATCH /admin/users/:id         # Suspend user

GET  /admin/events             # List all events
DELETE /admin/events/:id       # Delete event
GET  /admin/events/:id/edit    # Edit event form
PATCH /admin/events/:id        # Update event

GET  /admin/bookings           # List all bookings
PATCH /admin/bookings/:id/cancel # Cancel booking
```

### Organizer Routes

```
GET  /organizer                # Organizer dashboard
GET  /organizer/events         # List organizer's events
```

### Attendee Routes

```
GET  /attendee                 # Attendee dashboard
GET  /attendee/bookings        # List attendee's bookings
```

## Testing

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/booking_spec.rb

# Run with coverage report
bundle exec rspec --format progress --format RspecJunitXmlFormatter --out rspec.xml

# Run with verbose output
bundle exec rspec -v

# Run specific test
bundle exec rspec spec/models/booking_spec.rb:42
```

### Test Structure

```
spec/
├── models/              # Model tests
│   ├── user_spec.rb
│   ├── event_spec.rb
│   └── booking_spec.rb
├── requests/            # Controller/integration tests
│   ├── events_spec.rb
│   └── bookings_spec.rb
├── factories/           # FactoryBot definitions
│   └── users.rb
├── rails_helper.rb      # RSpec configuration
└── spec_helper.rb       # General RSpec setup
```

### Key Test Scenarios

- User registration and authentication
- Event creation and validation
- Booking creation with seat validation
- Overbooking prevention (concurrency)
- Authorization policies
- Email notifications
- Booking cancellation with seat release
- Dashboard access by role

### Continuous Integration

Run these commands before committing:

```bash
# Run all tests
bundle exec rspec

# Check code quality
bundle exec rubocop

# Security scan
bundle exec brakeman

# Check gems for vulnerabilities
bundle exec bundler-audit check
```

## Email Notifications

The system sends emails for:

### Booking Confirmation

- Triggered when booking is created
- Contains: Event details, booking confirmation, seat count

### Booking Cancellation

- Triggered when booking is cancelled
- Contains: Event details, refund info (if applicable)

### Email Configuration

**Development Environment** (uses Letter Opener):

- Emails are intercepted and displayed in browser
- Visit `http://localhost:3000/letter_opener` to view sent emails
- No external SMTP needed

**Production Environment**:

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  # Configure with your email service
}
```

## Key Business Logic

### Overbooking Prevention

When a user attempts to book seats:

1. **Lock event record** to prevent concurrent reads
2. **Calculate available seats** dynamically
3. **Validate** requested seats ≤ available seats
4. **Create booking** and decrement available seats atomically
5. **Send confirmation email**
6. **Unlock** and commit transaction

### Booking Cancellation

When a user cancels a booking:

1. **Verify** booking exists and belongs to user
2. **Check** event hasn't started yet
3. **Release** booked seats back to event
4. **Mark booking** as cancelled
5. **Send cancellation** email
6. **Update dashboard** in real-time

### Event Filtering

Events can be filtered by:

- **Date**: Upcoming events only (event_date > current time)
- **Search**: Title contains search query (case-insensitive)
- **Availability**: Only show events with available seats

## Troubleshooting

### Common Issues

#### "Bundler: command not found"

```bash
gem install bundler
```

#### Database connection errors

```bash
rails db:drop
rails db:create
rails db:migrate
```

#### Asset compilation failures

```bash
rails assets:precompile
rails assets:clobber
```

#### Port 3000 already in use

```bash
# Find process using port 3000
lsof -i :3000

# Kill the process (replace PID)
kill -9 <PID>

# Or use different port
rails server -p 3001
```

#### Email not sending in development

- Check `tmp/letter_opener` for email logs
- Verify ActionMailer is configured in `config/environments/development.rb`

#### Authorization errors

- Verify user role: Check `current_user.class` in Rails console
- Check policy in `app/policies/` matches your requirements
- Ensure user is authenticated: `authenticate_user!` before action

## Development Commands

```bash
# Start development server with auto-reload
./bin/dev

# Rails console for database exploration
rails console

# Generate database migration
rails generate migration CreateUsers

# View all routes
rails routes

# Run linting
bundle exec rubocop -A

# Security audit
bundle exec brakeman

# Dependency vulnerability check
bundle exec bundler-audit check

# View logs
tail -f log/development.log
```

## Deployment

For production deployment:

1. **Set environment variables** in hosting platform
2. **Configure database** (PostgreSQL recommended)
3. **Setup email service** (SendGrid, AWS SES, etc.)
4. **Configure asset storage** (AWS S3, etc.)
5. **Run migrations**: `rails db:migrate RAILS_ENV=production`
6. **Precompile assets**: `rails assets:precompile`
7. **Setup background jobs**: Configure Sidekiq with Redis

## Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes with clear commits
3. Run tests: `bundle exec rspec`
4. Run linters: `bundle exec rubocop`
5. Push to branch: `git push origin feature/your-feature`
6. Create a Pull Request

## License

This project is provided as-is for educational purposes.

## Support

For issues or questions:

1. Check the troubleshooting section
2. Review test files for usage examples
3. Check Rails/Devise/Pundit documentation
4. Examine application logs: `tail -f log/development.log`

---

**Last Updated**: May 2, 2026
**Version**: 1.0.0
