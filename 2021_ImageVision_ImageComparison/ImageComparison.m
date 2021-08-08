%Made By: Luis Enrique German Perdomo

clc;clear; 

%Parte 1
%Primeras Imagenes
im = imread('diferencias001a.png');  %cargado imagen1
im2 = imread('diferencias001b.png'); %cargado imagen2

dif = (im-im2)+(im2-im); %hallamos las diferencias absolutas
dif_gray = rgb2gray(dif); %escala de grises
dif_bin = imbinarize(dif_gray, 40/255); %binarizado

figure(1);
imshow(dif_bin); %visualizamos las diferencias

%obtenemos las ubicaciones de las diferencias y su area
data = regionprops(dif_bin,'Centroid'); 
centro = cat(1, data.Centroid); 
data = regionprops(dif_bin,'Area');
area = cat(1, data.Area);

figure(2);
imshow(im); %imprimimos circulos en las diferencias

for i = 1:length(area)
    if area(i,:) > 50  %solo si es una diferencia notable se imprime
        radio = sqrt(area(i,:)/pi);
        viscircles(centro(i,:), radio, 'Color', 'r');
    end
end

%Segundas Imagenes
im = imread('diferencias002a.png');  %cargado imagen1
im2 = imread('diferencias002b.png'); %cargado imagen2

im2(:,226,:) = []; %ajustamos los rengloes
im2(:,225,:) = []; %de la segunda imagen

figure(3);
obj = imshowpair(im,im2,'ColorChannels',[1 2 2]);
dif = obj.CData; %desplegamos las diferencias 

dif_modif = (im-im2)+(im2-im); %hallamos las diferencias absolutas
dif_gray = rgb2gray(dif_modif); %escala de grises
dif_bin = imbinarize(dif_gray,47/255); %binarizado
dif_clean = bwmorph(dif_bin,'clean'); %limpiamos el binarizado

figure(4);
imshow(dif_clean); %mostramos las diferencias 

%ubicamos los centroides de cada diferencia
data = regionprops(dif_clean,'Centroid'); 
centro = cat(1, data.Centroid); 
data = regionprops(dif_clean,'Area');
area = cat(1, data.Area);

figure(5);
imshow(im); %visualizamos imagen original

for i = 1:length(area)
    %ajustamos las condiciones para eliminar mas ruidos
    if  area(i,:) >= 39 && area(i,:) <= 42 || area(i,:) >= 50 && ...
            area(i,:) <= 50 || area(i,:) >= 60 && area(i,:) <= 65 || ...
            area(i,:) >= 100 || area(i,:) == 46 
        radio = sqrt(area(i,:)/pi);
        viscircles(centro(i,:), radio, 'Color', 'r');
    end
end

%Parte 2
img = imread('P002.bmp'); %cargamos imagen
im2 = imcrop(img,[340 80 15 20]); %recortamos letra a

figure(6); 
imshow(im2); %desplegamos letra a

r = xcorr2(img,im2); %matriz de correlacion
m = max(max(r)); %maximo de la matriz
r = r/m; %normalizamos la matriz
im = imbinarize(r, 220/255); %binarizado de la imagen
c1 = regionprops(im,'centroid'); %encontramos posicion de las letras
c1 = cat(1,c1.Centroid); %centroide de las letras
figure(7)
imshow(im); %vemos posicion de las letras

im4= imrotate(im2,270); %a rotada 270 grados
r2 = xcorr2(img,im4); %matriz de correlacion para a rotada
m1 = max(max(r2)); %valor maximo de la matriz
r2 = r2/m1; %correlacion normalizada
im12 = imbinarize(r2, 220/255); %binarizado de la imagen
c2 = regionprops(im12,'centroid'); %centro de las letras encontradas
c2 = cat(1,c2.Centroid);
figure(8)
imshow(im12); %ubicacion de las letras en imagen

img = cat(3,img,img,img); %patron en 3 dimensiones (RGB)

%for para recorrer toda la imagen recortada 
for i = (1:1:4)
    %recortado de letra a en la imagen
    crop = img(c1(i,2)-20:c1(i,2)+3,c1(i,1)-14:c1(i,1)+3,:);
    for y = 1:18
        for x = 1:24
            %condicion de pixeles blancos
            if (crop(x,y,1)> 180) && (crop(x,y,2) > 180) ...
                    && (crop(x,y,3) > 180)
                crop(x,y,1)= 255; %cambio de pixel blanco por rojo
                crop(x,y,2)= 0;
                crop(x,y,3)= 0;
            end
        end
    end
    img(c1(i,2)-20:c1(i,2)+3,c1(i,1)-14:c1(i,1)+3,:) = crop;
end

%segundo recortado de imaggen
crop2 = img(c2(1,2)-14:c2(1,2),c2(1,1)-20:c2(1,1),:);

%for para recorrer toda la imagen recortada 
for y = 1:21
    for x = 1:15
        %condicion de pixeles blancos
        if (crop2(x,y,1)> 180) && (crop2(x,y,2) > 180) ...
                && (crop2(x,y,3) > 180)
            crop2(x,y,1)= 255; %cambio de pixel blanco por rojo
            crop2(x,y,2)= 0;
            crop2(x,y,3)= 0;
        end
    end
end

%introducimos la imagen con letras rojas en la original
img(c2(1,2)-14:c2(1,2),c2(1,1)-20:c2(1,1),:) = crop2;

figure(9)
imshow(img); %vemos el resultado