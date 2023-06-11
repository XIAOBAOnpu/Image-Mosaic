function result = random_method(tilesAcross,method, alpha)
% 1. Read in a list of tiles 

directory='.\images';% location of the tiles
list = dir(['.\images\' '/*.' 'png']);% create a structure that gets the info of the files in the dir
n = size(list,1);
disp(['Loading ' num2str(n) ' tiles']);
%=====================================
i = 1;
while i <= n
    imageName = list(i).name;
    tiles{i} = imread([directory '/' imageName],'png');% gives the path and the extension and gets that imange in a cell datatype which is RGB arrays
    i = i + 1;
end % tiles{i:number of tiles} cnotaines 3D matrix for each tile 
%=====================================
i = 1;
while i <= length(tiles)
    currentTile = tiles{i};
    avg(i,1) = mean2(currentTile(:,:,1)); % average amount of the red matrix
    avg(i,2) = mean2(currentTile(:,:,2)); % average amount of the green matrix
    avg(i,3) = mean2(currentTile(:,:,3)); % average amount of the blue matrix
    i = i + 1;
end
%avg contains a vector that contains 3 avarage values for R,B,G for each tile 
%=====================================
testM = imread('2.bmp');
% we need to divide the testM into cells 
%determine tilesize, More tiles, more pixels ==> better resolution
 % the number of tiles in the width of the mosaic image {100} was chosen arbitrarily
[imgHeight, imgWidth, ~] = size(testM);% we only care about the first 2 returned values, which are the width and the hight of the image
[tileHeight, tileWidth, ~] = size(tiles{1});% we get and the width and height for tile images
cellWidth = floor(imgWidth/tilesAcross); % we need to find the size of the cell that we are going to divide the image into
cellHeight = round(cellWidth*(tileHeight/tileWidth)); % we need to keep the ratio of the width and height to be similar to the tiles 
tilesDown = floor(imgHeight/cellHeight);% the number of tiles in the height of the mosaic image 
%=====================================
% now we need to divide the image into the new cells with the right dim
for i = 1:tilesDown
    for j = 1:tilesAcross
        rows = (1+(i-1)*cellHeight):(i*cellHeight);
        cols = (1+(j-1)*cellWidth):(j*cellWidth);
        imgArray{i,j} = testM(rows,cols,:); % get the values of the new cell{cellWidth,cellHeight) for the 3 colors 
    end
end
% Imgarray is a 2d matrix (tilesAcross*tilesDown) of cells, each cell consists of cellWidth*cellHeight*3
%=====================================
% loop through Imgarray and get the averageRGB values {vector of 3 values}  for each cell.
for i=1:tilesDown
    for j=1:tilesAcross

        array(i,j,1)=mean2(imgArray {i,j}(:,:,1));
        array(i,j,2)=mean2(imgArray {i,j}(:,:,2));
        array(i,j,3)=mean2(imgArray {i,j}(:,:,3));
    end
end
%=====================================
% Preallocate the tileIndex array for performance.
tileIndex = zeros(tilesDown, tilesAcross);
%=====================================
%Choosing random tiles
tileIndex = randi(500,177,100);
%=====================================
% Find best tile for each image, based on the average RGB values 
% Loop through the rows and columns of the grid.
% for i = 1:tilesDown
%     for j = 1:tilesAcross
%         % go througj the average red, green and blue values for the current grid cell.
%         r = array(i,j,1);
%         g = array(i,j,2);
%         b = array(i,j,3);
%         mTemp = zeros(n, 1);% we need to compare with all tiles for every cell 
%         % Loop through the averge RGB values of each tile 
%         for k = 1:n
%             mTemp(k) = sum(abs(avg(k,:) - [r,g,b]));% compare the RGB values of each tiles with the cells values an store them
%         end
%         % Extract the lowest index value of the minimum value for mTemp
%         % and apply it to the correct position in the tileIndex array.
%         [~, tileIndex(i,j)] = min(mTemp);
%     end
% end
%=====================================
% assembler
%Piece together the mosaic by arranging the tiles in the correct positions in a cell array.
for i=1:tilesDown
    for j=1:tilesAcross
        mosaic{i,j} = tiles{tileIndex(i,j)}; % Assign the values of the best-Match tile to the mosaic cell 
    end
end
%=====================================
% color correction 

for i=1:tilesDown
    for j=1:tilesAcross
        mosaic {i,j}(:,:,1)= alpha.*double(array(i,j,1))+ ((1-alpha).*double(mosaic{i,j}(:,:,1)));
        mosaic {i,j}(:,:,2)= alpha.*double(array(i,j,2))+ ((1-alpha).*double(mosaic{i,j}(:,:,2)));
        mosaic {i,j}(:,:,3)= alpha.*double(array(i,j,3))+ ((1-alpha).*double(mosaic{i,j}(:,:,3)));
    end
end
%=====================================
%Transform the mosaic cell array into the final 3D matrix that represents our image.
mosaic = cell2mat(mosaic);
result=mosaic;
figure();
imshow(result)

end