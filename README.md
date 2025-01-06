# Vision-Based Robotics: Image Processing for Object Detection

This repository contains the implementation and report for the project **"Image Processing for Vision-Based Robotics Tasks"**.The project focused on developing vision-based techniques for detecting, localizing, and mapping orange traffic cones using MATLAB.

---

## Project Overview

### Objective
The goal of this project was to develop and implement algorithms to:
- Detect orange traffic cones using HSV color segmentation.
- Localize the cones based on their centroid positions.
- Calculate angular offsets and proximity relative to a mobile robot.
- Generate overhead views of cone positions for visualization.

### Features
- **Color Detection:** HSV-based segmentation for robust object identification.
- **Blob Analysis:** Identifying connected components for extracting cone centroids and areas.
- **Cone Localization:** Estimation of angular orientation and proximity of cones.
- **Dynamic Adjustments:** Robust detection under varying lighting and environmental conditions.
- **Visualization Tools:** Overhead views and annotated processed images for analysis.

---

## File Structure

### Key Files
- **`coneThreshold.m`**: MATLAB function for HSV-based color segmentation.
- **`detect_cone_centroids.m`**: Detects cone centroids and saves processed images.
- **`process_cone_images.m`**: Processes images to calculate angles, proximity, and overhead views.
- **`Lab_Report.pdf`**: Comprehensive report documenting the methodology, results, and conclusions.

---

## Getting Started

### Prerequisites
1. MATLAB R2023b or later.
2. Required MATLAB toolboxes:
   - Image Processing Toolbox
   - Computer Vision Toolbox

### Installation
1. Clone this repository:
    ```bash
    git clone https://github.com/Prayash-Das/Vision-Based-Robotics.git
    cd Vision-Based-Robotics
    ```
2. Add the MATLAB scripts to your MATLAB path.

### Running the Code

1. **Image Detection and Processing:**
    - Place your input images in the specified folder (e.g., `TrainConeImages`).
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

## Results

### Key Outcomes
- Successfully detected cones in training and test images under varying conditions.
- Extracted centroids, calculated angular positions, and estimated proximities.
- Generated clear overhead views for visualization.

### Challenges and Solutions
1. **Lighting Variations:** Adjusted HSV thresholds dynamically for better accuracy.
2. **Noise Removal:** Improved blob analysis with morphological operations.
3. **Proximity Calculation:** Dynamically scaled thresholds to handle varying cone sizes.

---

## Future Work
1. Expand the algorithm to handle real-time video input.
2. Integrate machine learning for adaptive color segmentation.
3. Incorporate 3D mapping for more precise localization.

---

## Contributors
- **Mohammad Althaf Syed**
- **Bhagyath Badduri**
- **Matthew Casey**
- **Prayash Das**

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## References
1. Gonzalez, R. C., & Woods, R. E. *Digital Image Processing* (4th ed.).
2. Corke, P. *Robotics, Vision and Control: Fundamental Algorithms in MATLAB®* (2nd ed.).
3. MATLAB Documentation: [Color Thresholder App](https://www.mathworks.com/help/images/color-thresholder-app.html).

For more details, refer to the [Lab Report](./Lab_Report.pdf).
