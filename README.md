# Vision-Based Robotics: Image Processing for Object Detection

![Project Overview](./images/project_overview.png)

This repository contains the implementation and report for the project **"Image Processing for Vision-Based Robotics Tasks"**. The project focused on developing vision-based techniques for detecting, localizing, and mapping orange traffic cones using MATLAB.

---

## Project Overview

### Objective
The goal of this project was to develop and implement algorithms to:
- Detect orange traffic cones using HSV color segmentation.
- Localize the cones based on their centroid positions.
- Calculate angular offsets and proximity relative to a mobile robot.
- Generate overhead views of cone positions for visualization.

---

## Results

### Cone Detection Example
![Cone Detection](./images/cone_detection_example.png)

### Overhead View Example
![Overhead View](./images/overhead_view_example.png)

---

## How to Use

1. **Image Detection and Processing:**
    - Place your input images in the `TrainConeImages` folder.
    - Run the centroid detection script:
      ```matlab
      detect_cone_centroids('TrainConeImages', 500);
      ```

2. **Overhead View Generation:**
    - Process images to generate overhead views:
      ```matlab
      process_cone_images('TestConeImages', 500);
      ```

3. **Visualize Results:**
    - Output processed images and overhead views are saved in the `Processed` folder.

---

## File Structure

### Key Files
- **`coneThreshold.m`**: MATLAB function for HSV-based color segmentation.
- **`detect_cone_centroids.m`**: Detects cone centroids and saves processed images.
- **`process_cone_images.m`**: Processes images to calculate angles, proximity, and overhead views.
- **`Lab_Report.pdf`**: Comprehensive report documenting the methodology, results, and conclusions.

---

## Contributors
- **Mohammad Althaf Syed**
- **Bhagyath Badduri**
- **Matthew Casey**
- **Prayash Das**

---

For more details, refer to the [Lab Report](./Lab_Report.pdf).
