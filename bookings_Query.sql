use ola;
select * from bookings;

# -----BOOKING STATUS AND CANCELLATION ANALYSIS-----
SELECT
COUNT(Booking_ID) AS Total_bookings,
SUM(CASE WHEN Booking_Status="Completed" THEN 1 ELSE 0 END) AS Successful_rides,
SUM(CASE WHEN Booking_Status in ('Cancelled by Driver','Cancelled by Customer')THEN 1 ELSE 0 END) AS Cancelled_rides,
ROUND(SUM(CASE WHEN Booking_Status in ('Cancelled by Driver','Cancelled by Customer')THEN 1 ELSE 0 END)*100/COUNT(Booking_ID),2) AS Cancelled_rate
FROM bookings;

# -----DRIVER PERFORMANCE AND RATING METRICS-----
SELECT 
    Driver_ID,
    ROUND(AVG(Driver_Rating), 2) AS Avg_Driver_Rating,
    ROUND(SUM(Trip_Distance), 2) AS Total_Distance_Traveled,
    COUNT(Booking_ID) AS Total_Trips
FROM Bookings
WHERE Driver_ID IS NOT NULL
GROUP BY Driver_ID
HAVING COUNT(Booking_ID)>=2
ORDER BY Avg_Driver_Rating DESC, Total_Distance_Traveled DESC;

# -----REVENUE AND PERFORMANCE BY VEHICLE TYPE-----
SELECT 
    Vehicle_Type,
    COUNT(Booking_ID) AS Total_Trips,
    ROUND(SUM(Ride_Fare), 2) AS Total_Revenue,
    ROUND(AVG(Ride_Fare), 2) AS Avg_Fare_Per_Trip,
    ROUND(AVG(`Avg_CTAT (min)`), 2) AS Avg_Customer_Wait_Time_Min
FROM bookings
WHERE Booking_Status = 'Completed'
GROUP BY Vehicle_Type
ORDER BY Total_Revenue DESC;

# -----AVERAGE TURN AROUND TIME BY VEHICLE TYPE-----
SELECT 
    Vehicle_Type,
    ROUND(AVG(`Avg_VTAT (min)`), 2) AS Avg_Vehicle_TAT_Min,
    ROUND(AVG(`Avg_CTAT (min)`), 2) AS Avg_Customer_TAT_Min
FROM bookings
WHERE Booking_Status = 'Completed'
GROUP BY Vehicle_Type;