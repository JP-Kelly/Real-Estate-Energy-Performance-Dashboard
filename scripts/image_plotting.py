import cv2
import numpy as np
import pandas as pd

# Load the image
image = cv2.imread("image path goes here")  # Replace with your image path

# Convert to grayscale to focus on intensity
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Apply Gaussian blur to reduce noise
blurred = cv2.GaussianBlur(gray, (5, 5), 0)

# Define a threshold to capture light grey areas
_, thresh = cv2.threshold(blurred, 200, 255, cv2.THRESH_BINARY)

# Find contours in the thresholded image
contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# Prepare lists to store the coordinates
house_coordinates = []
property_id = 1

# Loop over each contour to filter and capture house coordinates
for contour in contours:
    # Filter contours based on size to avoid very small detections
    area = cv2.contourArea(contour)
    if 50 < area < 1000:  # Adjust based on the approximate size of a house in your image
        # Calculate the center of each detected contour
        M = cv2.moments(contour)
        if M["m00"] != 0:
            cx = int(M["m10"] / M["m00"])
            cy = int(M["m01"] / M["m00"])

            # Rotate the coordinates by 90 degrees clockwise to ensure compatability when image is brought into Tableau
            rotated_x = image.shape[1] - cy
            rotated_y = cx

            # Determine property size based on area
            if area < 200:
                size = "small"
            elif area < 500:
                size = "medium"
            else:
                size = "large"

            house_coordinates.append((rotated_x, rotated_y, size, property_id))
            property_id += 1

# Save the coordinates to a CSV file
houses_df = pd.DataFrame(house_coordinates, columns=["x", "y", "size", "property_id"])
houses_df.to_csv("detected_houses_coordinates.csv", index=False)

print("House coordinates saved to detected_houses_coordinates_masked.csv")
