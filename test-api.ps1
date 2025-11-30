# PowerShell Test script for Hotel Reservation Management System
# This script tests all endpoints and demonstrates the three-layer architecture

$baseUrl = "http://localhost:3000/api"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Hotel Reservation Management System Test" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Create Users
Write-Host "1. Creating users..." -ForegroundColor Yellow
Write-Host "-------------------" -ForegroundColor Yellow
$user1Body = @{
    name = "Alice Johnson"
    email = "alice@example.com"
    number = "+1234567890"
} | ConvertTo-Json

$user1 = Invoke-RestMethod -Uri "$baseUrl/users" -Method Post -Body $user1Body -ContentType "application/json"
Write-Host "Created User 1:" -ForegroundColor Green
$user1 | ConvertTo-Json

$user2Body = @{
    name = "Bob Smith"
    email = "bob@example.com"
    number = "+0987654321"
} | ConvertTo-Json

$user2 = Invoke-RestMethod -Uri "$baseUrl/users" -Method Post -Body $user2Body -ContentType "application/json"
Write-Host "Created User 2:" -ForegroundColor Green
$user2 | ConvertTo-Json
Write-Host ""

# Test 2: Create Hotels
Write-Host "2. Creating hotels..." -ForegroundColor Yellow
Write-Host "--------------------" -ForegroundColor Yellow
$hotel1Body = @{
    hotelName = "Grand Plaza Hotel"
    location = "New York"
} | ConvertTo-Json

$hotel1 = Invoke-RestMethod -Uri "$baseUrl/hotels" -Method Post -Body $hotel1Body -ContentType "application/json"
Write-Host "Created Hotel 1:" -ForegroundColor Green
$hotel1 | ConvertTo-Json

$hotel2Body = @{
    hotelName = "Sunset Resort"
    location = "Miami"
} | ConvertTo-Json

$hotel2 = Invoke-RestMethod -Uri "$baseUrl/hotels" -Method Post -Body $hotel2Body -ContentType "application/json"
Write-Host "Created Hotel 2:" -ForegroundColor Green
$hotel2 | ConvertTo-Json
Write-Host ""

# Test 3: Get All Users
Write-Host "3. Getting all users..." -ForegroundColor Yellow
Write-Host "----------------------" -ForegroundColor Yellow
$allUsers = Invoke-RestMethod -Uri "$baseUrl/users" -Method Get
$allUsers | ConvertTo-Json
Write-Host ""

# Test 4: Get All Hotels
Write-Host "4. Getting all hotels..." -ForegroundColor Yellow
Write-Host "-----------------------" -ForegroundColor Yellow
$allHotels = Invoke-RestMethod -Uri "$baseUrl/hotels" -Method Get
$allHotels | ConvertTo-Json
Write-Host ""

# Test 5: Create Reservations
Write-Host "5. Creating reservations..." -ForegroundColor Yellow
Write-Host "--------------------------" -ForegroundColor Yellow
$reservation1Body = @{
    customerName = "Alice Johnson"
    phone = "+1234567890"
    location = "New York"
    mail = "alice@example.com"
    date = "2025-12-15T14:00:00Z"
    userId = $user1.id
    hotelId = $hotel1.id
} | ConvertTo-Json

$reservation1 = Invoke-RestMethod -Uri "$baseUrl/reservations" -Method Post -Body $reservation1Body -ContentType "application/json"
Write-Host "Created Reservation 1:" -ForegroundColor Green
$reservation1 | ConvertTo-Json
Write-Host ""
Write-Host "Check your application console for RabbitMQ event: 'reservation_created'" -ForegroundColor Magenta
Write-Host ""

$reservation2Body = @{
    customerName = "Bob Smith"
    phone = "+0987654321"
    location = "Miami"
    mail = "bob@example.com"
    date = "2025-12-20T10:00:00Z"
    userId = $user2.id
    hotelId = $hotel2.id
} | ConvertTo-Json

$reservation2 = Invoke-RestMethod -Uri "$baseUrl/reservations" -Method Post -Body $reservation2Body -ContentType "application/json"
Write-Host "Created Reservation 2:" -ForegroundColor Green
$reservation2 | ConvertTo-Json
Write-Host ""
Write-Host "Check your application console for RabbitMQ event: 'reservation_created'" -ForegroundColor Magenta
Write-Host ""

# Test 6: Get All Reservations
Write-Host "6. Getting all reservations with related data..." -ForegroundColor Yellow
Write-Host "------------------------------------------------" -ForegroundColor Yellow
$allReservations = Invoke-RestMethod -Uri "$baseUrl/reservations" -Method Get
$allReservations | ConvertTo-Json -Depth 5
Write-Host ""

# Test 7: Update a Reservation
Write-Host "7. Updating a reservation..." -ForegroundColor Yellow
Write-Host "---------------------------" -ForegroundColor Yellow
$updateBody = @{
    date = "2025-12-16T15:00:00Z"
} | ConvertTo-Json

$updated = Invoke-RestMethod -Uri "$baseUrl/reservations/$($reservation1.id)" -Method Patch -Body $updateBody -ContentType "application/json"
Write-Host "Updated Reservation:" -ForegroundColor Green
$updated | ConvertTo-Json
Write-Host ""
Write-Host "Check your application console for RabbitMQ event: 'reservation_updated'" -ForegroundColor Magenta
Write-Host ""

# Test 8: Get Single Reservation
Write-Host "8. Getting single reservation..." -ForegroundColor Yellow
Write-Host "--------------------------------" -ForegroundColor Yellow
$singleReservation = Invoke-RestMethod -Uri "$baseUrl/reservations/$($reservation1.id)" -Method Get
$singleReservation | ConvertTo-Json -Depth 5
Write-Host ""

# Test 9: Get User with Reservations
Write-Host "9. Getting user with reservations..." -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Yellow
$userWithReservations = Invoke-RestMethod -Uri "$baseUrl/users/$($user1.id)" -Method Get
$userWithReservations | ConvertTo-Json -Depth 5
Write-Host ""

# Test 10: Get Hotel with Reservations
Write-Host "10. Getting hotel with reservations..." -ForegroundColor Yellow
Write-Host "--------------------------------------" -ForegroundColor Yellow
$hotelWithReservations = Invoke-RestMethod -Uri "$baseUrl/hotels/$($hotel1.id)" -Method Get
$hotelWithReservations | ConvertTo-Json -Depth 5
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Test Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Architecture Layers Demonstrated:" -ForegroundColor Yellow
Write-Host "1. API Layer (REST): All HTTP endpoints tested" -ForegroundColor White
Write-Host "2. Data Layer (Prisma): Database operations with relations" -ForegroundColor White
Write-Host "3. Messaging Layer (RabbitMQ): Events logged in console" -ForegroundColor White
Write-Host ""
Write-Host "Check your application console to see RabbitMQ event messages!" -ForegroundColor Magenta
