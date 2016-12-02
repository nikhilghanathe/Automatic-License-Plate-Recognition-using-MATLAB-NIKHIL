PROCEDURE TO RUN:
1. I have tested the algorithm on MATLAB Version 7.13.0.564 (R2011b). Hope the algorithm will work on higher versions for sure and for lesser not guaranteed.

2. Copy all the files (.m files and image files) from the folder 'Number_Plate_Extraction' in the current directory of MATLAB or where MATLAB can locate in its path.

3. Ten(10) images are supplied for the testing of the algorithm.

4. Run the file named 'numberPlateExtraction' on the command prompt.

5. I have set the image 'car3.jpg' in "imread" function. If the other nine images are to be tested modify the "imread" command in the "numberPlateExtraction" file as follows:

f=imread('sshz1.jpg');
f=imread('car3.jpg');
f=imread('carplate2.jpg'); and so on


SPECIFICATIONS:
If you are testing some other number plate images make sure that the image is not blurred, no reflection of light from any character, number plate should be dominant, prominent and distinct in the image. If number plate is from other (Karachi) city or country then please modify the code as mentioned in the comments of .m files accordingly. In our city there are '6' characters on every number plate. If you are running for other than '6' please modify accordingly in 'controlling.m' and 'guessthesix.m' files.
If the character is touching the boundary of plate or each other, extraction will not be succesfull as with the image "pic7". Plate should not be fancy i.e the characters should all along a single line. Further more the characters should be conventional one. For example in the image "carplate1" character '2' is not a conventional so it prints 'Z' insteadof '2'.
The characters of "pic5" are not evident so program is unable to extract the characters. 
