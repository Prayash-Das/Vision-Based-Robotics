function process_cone_images(processing_image_folder, area_threshold)
    % process_cone_images - Processes images to detect and save centroids of cones
    % Additionally calculates angles, proximity, and generates an overhead view
    %
    % Parameters:
    %   processing_image_folder (string): Path to the folder containing images for processing
    %   area_threshold (int): Minimum area size to consider a region as a cone

    original_image_folder = '/Users/prayashdas/Documents/MATLAB/ME598_ImgProcLab_MATLAB/TrainConeImages';

    % Get list of images in the folder
    image_files = dir(fullfile(processing_image_folder, '*.jpg')); 
    output_folder = 'Processed'; % Folder to save processed images

    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Initialize structure to store results for plotting
    allresults = struct();

    for i = 1:length(image_files)
        % Load the processed image
        img_path = fullfile(processing_image_folder, image_files(i).name);
        CD = imread(img_path);
        
        % Load the original image for plotting
        original_path = fullfile(original_image_folder, image_files(i).name);
        original_image = imread(original_path);

        % Convert to binary if the image is grayscale
        if size(CD, 3) == 3
            CD = rgb2gray(CD);
        end
        CD = imbinarize(CD); 
        % Get the size of the image
        [nr, nc] = size(CD);
        ImageCenterX = nc / 2;

        % Step 1: Filtering out connected pixel regions smaller than a user-defined threshold
        CDfiltered = bwareaopen(CD, area_threshold);

        % Step 2: Labeling the connected components
        L = bwlabel(CDfiltered);

        % Step 3: Extracting properties of each labeled region
        stats = regionprops(L, 'Area', 'Centroid');
        areas = [stats.Area];
        centroids = cat(1, stats.Centroid);

        % Step 4: Checking for valid regions and handle cases for 0, 1, or 2 cones
        disp(['Processing Image: ', image_files(i).name]);
        if isempty(areas)
            disp('No cones detected.');
            disp('---------------------------------------------');
            continue; 
        end

        % Find the two largest areas that meet the area threshold
        [sorted_areas, sort_idx] = sort(areas, 'descend');
        valid_centroids = [];
        valid_areas = [];
        for idx = 1:min(2, length(sorted_areas)) 
            if sorted_areas(idx) >= area_threshold
                valid_centroids = [valid_centroids; centroids(sort_idx(idx), :)];
                valid_areas = [valid_areas; sorted_areas(idx)];
            end
        end

        % Dynamically determine area thresholds for proximity
        max_area = max(valid_areas);
        min_area = min(valid_areas);
        mid_area = (max_area + min_area) / 2;

        % Calculating orientation angles and proximity for each centroid
        angles = [];
        proximity = [];
        for k = 1:size(valid_centroids, 1)
            CentroidX = valid_centroids(k, 1);
            Xdiff = CentroidX - ImageCenterX;

            angle = -(Xdiff / ImageCenterX) * 30; % ±30° range
            angles = [angles; angle];

            % Determining proximity based on dynamically calculated thresholds
            if valid_areas(k) >= mid_area
                prox = 1; % Near
            elseif valid_areas(k) > min_area
                prox = 2; % Medium
            else
                prox = 3; % Far
            end
            proximity = [proximity; prox];
        end

        % Display centroids, angles, and proximity in the command window
        disp('Centroid coordinates:');
        for k = 1:size(valid_centroids, 1)
            fprintf('  Cone %d: [%.2f, %.2f]\n', k, valid_centroids(k, 1), valid_centroids(k, 2));
        end
        disp('Orientation angles (degrees):');
        for k = 1:length(angles)
            fprintf('  Cone %d: %.2f°\n', k, angles(k));
        end
        disp('Proximity levels:');
        for k = 1:length(proximity)
            fprintf('  Cone %d: %d\n', k, proximity(k));
        end
        disp('---------------------------------------------');

        % Generating overhead view of cone positions
        if ~isempty(angles) && ~isempty(proximity)
            fignum = 100 + i; % Unique figure number
            figure(fignum);
            overheadView(angles, proximity, fignum);
            overhead_image_path = fullfile(output_folder, ['Overhead_', image_files(i).name]);
            saveas(gcf, overhead_image_path); % Save overhead figure
            close(gcf); % Close the figure after saving
        end

        % Store original and overhead images for plotting
        allresults(i).fileName = original_image;
        allresults(i).output = imread(overhead_image_path); % Load the saved overhead image
    end

    % Plotting original and overhead images
    % Above / Below layout
    for iter = 1:size(allresults, 2)
        figure;
        subplot(2, 1, 1);
        imshow(allresults(iter).fileName);
        title('Original');
        subplot(2, 1, 2);
        imshow(allresults(iter).output);
        title('Overhead View');
    end

    % Left / Right layout
    for iter = 1:size(allresults, 2)
        figure;
        subplot(1, 2, 1);
        imshow(allresults(iter).fileName);
        title('Original');
        subplot(1, 2, 2);
        imshow(allresults(iter).output);
        title('Overhead View');
    end
end

function filled_image = flood_fill(image, start_point)
    % flood_fill - Custom flood-fill to fill larger black areas within white regions.
    %
    % Parameters:
    %   image (binary matrix): Binary image with black (0) and white (1) pixels
    %   start_point (1x2 array): [x, y] coordinates of the starting point (centroid)
    %
    % Returns:
    %   filled_image: Binary image with larger internal black pixels filled

    filled_image = image;
    queue = [start_point];

    while ~isempty(queue)
        point = queue(1, :);
        queue(1, :) = []; % Pop from queue
        x = point(1);
        y = point(2);

        % Check bounds and only process black pixels
        if x > 1 && x < size(filled_image, 2) && y > 1 && y < size(filled_image, 1)
            if filled_image(y, x) == 0 % Black pixel to be filled
                filled_image(y, x) = 1; % Fill with white

                % Adding adjacent pixels to queue
                queue = [queue; x+1, y; x-1, y; x, y+1; x, y-1];
            end
        end
    end
end
