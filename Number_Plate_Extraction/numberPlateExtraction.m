function numberPlateExtraction
%This function extracts the number plate characters from the number plate
%image

f=imread('ABH3.jpg'); % Reading the number plate image.
imshow(f);
f=imnoise(f,'salt & pepper',0.08);
imshow(f);
f=imresize(f,[400 NaN]); % Resizing the image keeping aspect ratio same.
g=rgb2gray(f); % Converting the RGB (color) image to gray (intensity).

%%%%%%% prefiltering for noise removal %%%%%%%
g=medfilt2(g,[3 3]); % Median filtering to remove noise.
figure, imshow(g), title('after filtering');
%%%%%%%% Edge enhancement %%%%%%%
[~, threshold] = edge(g, 'sobel');
fudgeFactor = .70;
BWs = edge(g,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');
se=strel('disk',3); % Structural element (disk of radius 1) for morphological processing.
gi=imdilate(BWs,se); % Dilating the gray image with the structural element.
ge=imerode(BWs,se); % Eroding the gray image with structural element.
gdiff=imsubtract(gi,ge); % Morphological Gradient for edges enhancement.
BWnobord = imclearborder(gdiff, 26);
figure, imshow(BWnobord), title('cleared border image');

%%%%%% converting matrix form to image%%%%%
gdiff=mat2gray(BWnobord); % Converting the class to double.
%%%% image edge enhancement
gdiff=conv2(gdiff,[1 1;1 1]); % Convolution of the double image for brightening the edges.
gdiff=imadjust(gdiff,[0.5 0.7],[0 1],0.1); % Intensity scaling between the range 0 to 1.
figure, imshow(gdiff), title('convoluted');
B=logical(gdiff); % Conversion of the class from double to binary. 

% Eliminating the possible horizontal lines from the output image of regiongrow
% that could be edges of license plate.
er=imerode(B,strel('line',50,0));
out1=imsubtract(B,er);

% Filling all the regions of the image.
F=imfill(out1,'holes');
F=imclearborder(F, 6);
figure, imshow(F), title('after filling and elimination of horizantal lines');
% Thinning the image to ensure character isolation.
%figure, imshow(F), title('filled');
H=bwmorph(F,'thin',3);
%figure,imshow(H);

 H=imerode(H,strel('line',2,90));

 % Selecting all the regions that are of pixel area more than 100.
final=bwareaopen(H,150);
figure,imshow(final);
figure, imshow(final), title('input ot character recognition module');
% final=bwlabel(final); % Uncomment to make compitable with the previous versions of MATLAB®
% Two properties 'BoundingBox' and binary 'Image' corresponding to these
% Bounding boxes are acquired.
Iprops=regionprops(final,'BoundingBox','Image')
field=fieldnames(Iprops);
%imshow(Iprops.Image);
% Selecting all the bounding boxes in matrix of order numberofboxesX4;
NR=cat(1,Iprops.BoundingBox);
% Calling of controlling function.
r=controlling(NR); % Function 'controlling' outputs the array of indices of boxes required for extraction of characters.
if ~isempty(r) % If succesfully indices of desired boxes are achieved.
    I={Iprops.Image}; % Cell array of 'Image' (one of the properties of regionprops)
    noPlate=[]; % Initializing the variable of number plate string.
    for v=1:length(r)
        N=I{1,r(v)}; % Extracting the binary image corresponding to the indices in 'r'.
        letter=readLetter(N); % Reading the letter corresponding the binary image 'N'.
        while letter=='O' || letter=='0' % Since it wouldn't be easy to distinguish
            if v<=3                      % between '0' and 'O' during the extraction of character
                letter='O';              % in binary image. Using the characteristic of plates in Karachi
            else                         % that starting three characters are alphabets, this code will
                letter='0';              % easily decide whether it is '0' or 'O'. The condition for 'if'
            end                          % just need to be changed if the code is to be implemented with some other
            break;                       % cities plates. The condition should be changed accordingly.
        end
        noPlate=[noPlate letter]; % Appending every subsequent character in noPlate variable.
    end
%     fid = fopen('noPlate.txt', 'wt'); % This portion of code writes the number plate
%     fprintf(fid,'%s\n',noPlate);      % to the text file, if executed a notepad file with the
%     fclose(fid);                      % name noPlate.txt will be open with the number plate written.
%     winopen('noPlate.txt')
    noPlate
    winopen(strcat('AED632','.txt'));
        
    
%     Uncomment the portion of code below if Database is  to be organized. Since my
%     project requires database so I have written this code. DB is the .mat
%     file containing the array of structure of all entries of database.
%     load DB
%     for x=1:length(DB)
%         recordplate=getfield(DB,{1,x},'PlateNumber');
%         if strcmp(noPlate,recordplate)
%             disp(DB(x));
%             disp('*-*-*-*-*-*-*');
%         end
%     end
    
else % If fail to extract the indexes in 'r' this line of error will be displayed.
    fprintf('Unable to extract the characters from the number plate.\n');
    fprintf('The characters on the number plate might not be clear or touching with each other or boundries.\n');
end
end