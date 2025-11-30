#!/bin/bash

# Test script for Hotel Reservation Management System
# This script tests all endpoints and demonstrates the three-layer architecture

BASE_URL="http://localhost:3000/api"

echo "========================================="
echo "Hotel Reservation Management System Test"
echo "========================================="
echo ""

# Test 1: Create Users
echo "1. Creating users..."
echo "-------------------"
USER1=$(curl -s -X POST $BASE_URL/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice Johnson",
    "email": "alice@example.com",
    "number": "+1234567890"
  }')
echo "Created User 1: $USER1"

USER2=$(curl -s -X POST $BASE_URL/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Bob Smith",
    "email": "bob@example.com",
    "number": "+0987654321"
  }')
echo "Created User 2: $USER2"
echo ""

# Test 2: Create Hotels
echo "2. Creating hotels..."
echo "--------------------"
HOTEL1=$(curl -s -X POST $BASE_URL/hotels \
  -H "Content-Type: application/json" \
  -d '{
    "hotelName": "Grand Plaza Hotel",
    "location": "New York"
  }')
echo "Created Hotel 1: $HOTEL1"

HOTEL2=$(curl -s -X POST $BASE_URL/hotels \
  -H "Content-Type: application/json" \
  -d '{
    "hotelName": "Sunset Resort",
    "location": "Miami"
  }')
echo "Created Hotel 2: $HOTEL2"
echo ""

# Test 3: Get All Users
echo "3. Getting all users..."
echo "----------------------"
curl -s -X GET $BASE_URL/users | jq '.'
echo ""

# Test 4: Get All Hotels
echo "4. Getting all hotels..."
echo "-----------------------"
curl -s -X GET $BASE_URL/hotels | jq '.'
echo ""

# Test 5: Create Reservations
echo "5. Creating reservations..."
echo "--------------------------"
RESERVATION1=$(curl -s -X POST $BASE_URL/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Alice Johnson",
    "phone": "+1234567890",
    "location": "New York",
    "mail": "alice@example.com",
    "date": "2025-12-15T14:00:00Z",
    "userId": 1,
    "hotelId": 1
  }')
echo "Created Reservation 1: $RESERVATION1"
echo ""
echo "Check your application console for RabbitMQ event: 'reservation_created'"
echo ""

RESERVATION2=$(curl -s -X POST $BASE_URL/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Bob Smith",
    "phone": "+0987654321",
    "location": "Miami",
    "mail": "bob@example.com",
    "date": "2025-12-20T10:00:00Z",
    "userId": 2,
    "hotelId": 2
  }')
echo "Created Reservation 2: $RESERVATION2"
echo ""
echo "Check your application console for RabbitMQ event: 'reservation_created'"
echo ""

# Test 6: Get All Reservations
echo "6. Getting all reservations with related data..."
echo "------------------------------------------------"
curl -s -X GET $BASE_URL/reservations | jq '.'
echo ""

# Test 7: Update a Reservation
echo "7. Updating a reservation..."
echo "---------------------------"
UPDATED=$(curl -s -X PATCH $BASE_URL/reservations/1 \
  -H "Content-Type: application/json" \
  -d '{
    "date": "2025-12-16T15:00:00Z"
  }')
echo "Updated Reservation: $UPDATED"
echo ""
echo "Check your application console for RabbitMQ event: 'reservation_updated'"
echo ""

# Test 8: Get Single Reservation
echo "8. Getting single reservation..."
echo "--------------------------------"
curl -s -X GET $BASE_URL/reservations/1 | jq '.'
echo ""

# Test 9: Get User with Reservations
echo "9. Getting user with reservations..."
echo "------------------------------------"
curl -s -X GET $BASE_URL/users/1 | jq '.'
echo ""

# Test 10: Get Hotel with Reservations
echo "10. Getting hotel with reservations..."
echo "--------------------------------------"
curl -s -X GET $BASE_URL/hotels/1 | jq '.'
echo ""

echo "========================================="
echo "Test Complete!"
echo "========================================="
echo ""
echo "Architecture Layers Demonstrated:"
echo "1. API Layer (REST): All HTTP endpoints tested"
echo "2. Data Layer (Prisma): Database operations with relations"
echo "3. Messaging Layer (RabbitMQ): Events logged in console"
echo ""
echo "Check your application console to see RabbitMQ event messages!"
