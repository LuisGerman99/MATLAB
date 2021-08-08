%Made By: Luis Enrique German Perdomo     - 
clc;clear;

%Punto 1
figure(1);
im = imread('image01.png'); %leemos imagen
imshow(im);

figure(2);
im_gray = rgb2gray(im); %Convertimos a gris
[im_gray_ind, map] = gray2ind(im_gray,8); %Convertimos a 8 diferentes gris
imshow(im_gray_ind, map); %desplegamos resultado

figure(3);
map(1,:) = [0 0 0]; %negro
map(2,:) = [128 0 128]/255; %morado
map(3,:) = [0 0 255]/255;%azul
map(4,:) = [0 255 255]/255;%cyan
map(5,:) = [0 128 0]/255;%verde
map(6,:) = [255 255 0]/255;%amarillo
map(7,:) = [255 165 0]/255;%naranja
map(8,:) = [255 0 0]/255;%rojo
imshow(im_gray_ind, map);

%Punto 2
figure(4);
im = imread('P001.jpg');
imshow(im);

figure(5);
im_gray = rgb2gray(im); %convertimos a escala de grises 
im_bw1 = imbinarize(im_gray, 45/255); %eliminamos el circulo
im_bw2 = imbinarize(im_gray, 27/255); %todos las figuras
im_bw = im_bw2-im_bw1; %restamos ambas imagenes 
imshow(im_bw); %desplegamos unicamente el circulo

figure(6);
data = regionprops(im_bw,'Centroid'); 
centro = cat(1, data.Centroid); %centro del circulo
data = regionprops(im_bw,'Area');
area = cat(1, data.Area); %area del criculo
radio = sqrt(area/pi); %radio del circulo
imshow(im);
viscircles(centro, radio, 'Color', 'r'); %dibujado de circunferencia

%Punto 3 
figure(7);
im = imread('P003.jpg');
imshow(im);

figure(8);
im_gray = rgb2gray(im); %convertimos a escala de grises 
im_bw = imbinarize(im_gray, 200/255); %eliminamos el circulo
imshow(im_bw);

figure(9);
data = regionprops(im_bw,'Centroid'); 
centro = cat(1, data.Centroid); %centro del circulo
centro = centro(35,:);
data = regionprops(im_bw,'Area');
area = cat(1, data.Area); %area del circulo
area = area(35);
radio = sqrt(area/pi); %radio del circulo
centro_imagen = insertText(im, [centro(1) centro(2)-30], '115.0909 88.6182');
dot = insertMarker(centro_imagen, centro);
imshow(dot);
viscircles(centro, radio, 'Color', 'r');