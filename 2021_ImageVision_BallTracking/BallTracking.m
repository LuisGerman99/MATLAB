%Hecho por: Luis Enrique German Perdomo

ReadObj = VideoReader('singleball.avi'); %Cargado del video
NumFrames = ReadObj.NumberOfFrames; %Frames del video
diametro_golf = 4.3; %cm de la pelota de golf
diametro_video = 7.270873*2; %pixeles de diametro de la pelota
fps = 30; %frames por segundo
hora = 3600; %segundos de una hora
m = 100; %centimetros de un km
%relacion para transformar de cm/s 
relacion = (diametro_golf/diametro_video)*(fps)/(m);

for k = 1:NumFrames
    peli(k).cdata = read(ReadObj, k);
    peli(k).colormap = [];
    I = peli(k).cdata;
    [centro, radii] = imfindcircles(I, [6 15],'ObjectPolarity',...
        'bright','EdgeThreshold', 0.03);
    if ~isempty(centro)
        location(k,:) = [centro(1,:), radii];
        if location(k-1,1) ~= 0 
            velocidad = sqrt((location(k,1)-location(k-1,1))^2+...
                (location(k,2)-location(k-1,2))^2)*relacion;
        else    
            velocidad = 0;
        end
        if track(k-1,3) == 0 
            track(k-1,:) = [0,0,0,0];
            track(k,:) = [centro(1,:), centro(1,:)];  
        else
            track(k,:) = [track(k-1,3:4),centro(1,:)];
        end  
    else
        location(k,:) = [0,0,0];
        track(k,:) = [0,0,0,0];
        velocidad = 0;
    end
    peli(k).cdata = insertShape(I, 'Line',track(1:k,:),'LineWidth',3,...
         'Color','red');
    peli(k).cdata = insertShape(peli(k).cdata,'circle',location,...
        'LineWidth',2,'Color','blue');
    peli(k).cdata = insertText(peli(k).cdata,[330 5],...
        ['Velocidad: ' num2str(velocidad) 'm/s']); 
end

figure(3);
movie(peli,1,30);

video = VideoWriter('Tracking.avi','Uncompressed AVI');
open(video);
writeVideo(video, peli);
close(video);