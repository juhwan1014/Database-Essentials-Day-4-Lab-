# Database-Essentials-Day-4-Lab-

## Requirements
Add to your lab 3 .sql script:

1. A scalar function called fnGetFullName
2. A table function called fnGetTicketLabels that takes a SaleId parameter to return a result formatted like the following:

`Test Event: SEC1 - Row 1 - Seat 1`

`Test Event: SEC1 - Row 1 - Seat 2`

3. A scalar function called fnGetBlock that takes a SaleId and displays the following: 

`Test Event: SEC1 - Row 1 - (1,2,3,4)`

4. A stored procedure that displays the Venue Name, Event Name, Date, Start Time, and the number of available seats of all up coming events.

5. A stored procedure that takes an event id as a parameter and displays two results:
   
   a. purchased tickets (CustomerId, TicketBlock)
   
   b. available tickets (Section, Row, Seat Count)
