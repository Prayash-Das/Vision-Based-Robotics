function detect_cone_centroids(image_folder, area_threshold)
    % detect_cone_centroids - Detects and saves centroids of cones in all images in a folder
    %
    % Parameters:
    %   image_folder (string): Path to the folder containing images
    %   area_threshold (int): Minimum area size to consider a region as a cone

    % Get list of images in the folder
    image_files = dir(fullfile(image_folder, '*.jpg')); 
    output_folder = 'output_centroids'; % Folder to save results

    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    for i = 1:length(image_files)
        % Load the current image
        img_path = fullfile(image_folder, image_files(i).name);
        CD = imread(img_path);
        
        % Convert to binary if the image is grayscale
        if size(CD, 3) == 3
            CD = rgb2gray(CD);
        end
        CD = imbinarize(CD); 

        % Step 1: Filtering out connected pixel regions smaller than a user-defined threshold
        CDfiltered = bwareaopen(CD, area_threshold);

        % Step 2: Labeling the connected components
        L = bwlabel(CDfiltered);

        % Step 3: Extracting properties of each labeled region
        stats = regionprops(L, 'Area', 'Centroid');
        areas = [stats.Area];
        centroids = cat(1, stats.Centroid);

        % Step 4: Checking for valid regions and handle cases for 0, 1, or 2 cones
        disp(['Image: ', image_files(i).name]);
        if isempty(areas)
            disp('Centroid coordinates: []'); % No cones detected
            continue; 
        end

        % Finding the two largest areas that meet the area threshold
        [sorted_areas, sort_idx] = sort(areas, 'descend');
        valid_centroids = [];
        for idx = 1:min(2, length(sorted_areas)) 
            if sorted_areas(idx) >= area_threshold
                valid_centroids = [valid_centroids; centroids(sort_idx(idx), :)];
            end
        end

        % Printing centroid coordinates
        if isempty(valid_centroids)
            disp('Centroid coordinates: []');
            disp('Size: [0 0]');
            continue;
        else
            disp('Centroid coordinates:');
            for k = 1:size(valid_centroids, 1)
                fprintf('[%.2f, %.2f]\n', valid_centroids(k,1), valid_centroids(k,2));
            end
        end

        % Step 5: Applying iterative closing to fill smaller internal black regions
        se_small = strel('disk', 5); % Small disk for closing small gaps
        CDfilled = CDfiltered;
        while true
            CDclosed = imclose(CDfilled, se_small);
            if isequal(CDclosed, CDfilled)
                break;
            end
            CDfilled = CDclosed;
        end

        % Step 6: Applying flood-fill from each centroid to capture larger internal holes
        for k = 1:size(valid_centroids, 1)
            CDfilled = flood_fill(CDfilled, round(valid_centroids(k, :)));
        end

        % Display the modified image with filled regions
        figure('Visible', 'off');
        imshow(CDfilled);
        hold on;

        % Step 7: Plot the centroids on the modified image
        for k = 1:size(valid_centroids, 1)
            plot(valid_centroids(k,1), valid_centroids(k,2), 'b*', 'MarkerSize', 10);
    
        % Display the coordinates next to the centroid
        text(valid_centroids(k,1) + 5, valid_centroids(k,2), ...
        sprintf('[%.2f, %.2f]', valid_centroids(k,1), valid_centroids(k,2)), ...
        'Color', 'blue', 'FontSize', 10, 'FontWeight', 'bold');
        end


        % Save the output image
        [~, name, ext] = fileparts(image_files(i).name);
        saveas(gcf, fullfile(output_folder, ['centroids_' name ext]));
        close(gcf);
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

                % Add adjacent pixels to queue
                queue = [queue; x+1, y; x-1, y; x, y+1; x, y-1];
            end
        end
    end
end