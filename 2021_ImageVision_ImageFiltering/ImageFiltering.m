%Made By: Luis Enrique German Perdomo

clc;clear;

%Punto 2
im = imread('coins.png'); %Cargamos Imagen
figure(1)
imshow(im) %Desplegamos

%Punto 3
im_new = imrotate(im,90); %Rotamos la imagen
im_new = imresize(im_new,1.5); %Amplificamos 50%
figure(2);
imshow(im_new) %Desplegamos REsultado

%Punto 4
im_new2 = adapthisteq(im, "clipLimit", 0.05, "NumTiles", [10 10]); 
figure(3);
imshow(im_new2); %Desplegamos 

%Punto 5
im_new3 = histeq(im,16); %Reducimos a 16
figure(4);
imshow(im_new3);
im_new4 = histeq(im,4); %4 niveles de gris
figure(5);
imshow(im_new4);

%Punto 6
im_noise1 = imnoise(im,"gaussian"); %Ruido 1
im_noise2 = imnoise(im_noise1,"poisson"); %Ruido 2

    %Diseño de Filtros
filtro1 = fspecial('log',[246 300], 0.51);
im_filtro1 = imfilter(im_noise2, filtro1);
im_filtro2 = imgaussfilt(im_filtro1);
im_filtro3 = imgaussfilt3(im_filtro2);
im_filtro4 = adapthisteq(im_filtro3, "clipLimit", 0.001, "NumTiles", [8 8]);

figure(6);
subplot(1,2,1);
imshow(im_noise2);
title("Imagen con Ruido");
subplot(1,2,2);
imshow(im_filtro4);
title("Imagen Filtrada");