%Made By: Luis Enrique German Perdomo

clc;clear;

%Parte 1 Diseño de Filtro FIR

Fs = 25000; %Frecuencia de muestreo
Fp = 5000; % Frecuencia de corte lowpass
Wp = Fp/(Fs/2); %Frecuencia de corte normalizada
Ws = 10000/(Fs/2); %Frecuencia de stop normalizada
[n,Wn]=buttord(Wp,Ws,3,20,'s'); % Orden del filtro, 
[num,den] = butter(n,Wn); % Filtro butter (analogico)

figure(1); 
freqz(num,den); %Grafica de repuesta en frecuencia normalizada (0-12.5kHz)

f = [0 0.4   0.8  1]; %Frecuencias de corte y stop normalizadas
A = [1 0.5  0.004 0]; %Vector de ganancia
n = fir2(300,f,A); % Filtor FIR 

figure(2)
freqz(n,1); % Plotear frecuencia normalizada (0-12.5kHz)

%-------------------------------------------------------------------------------
%Parte 2 Audio con Ruido

[y Fs] = audioread('Sasageyo_Original.wav'); %Cargado de Audio de 10 sec
y = y';

T = 1/Fs; 
L = length(y);
t = (0:L-1)*T;

figure(3)
frec_original = fft(y); %Frecuencias de Audio Original
f = [0:Fs/(length(frec_original)-1):Fs]; %vector de frecuencias 
plot(f, abs(frec_original)); %Grafica de Frecuencias del Audio Original
title("Frecuencias Audio Original");
xlabel("Frecuencia (Hz)"); ylabel("Amplitud (dB)");
xlim([0 Fs]);

ruido1 = 0.1*sin(4000*2*pi*t); %Generamos el ruido de 4000Hz con amplitud 0.1
figure(4);
frec_ruido1 = fft(ruido1); %Frecuencias del ruido 1
plot(f,abs(frec_ruido1)); %Grafica de Frecuencias del Ruido 1
title("Frecuencias Ruido l");
xlabel("Frecuencia (Hz)"); ylabel("Amplitud (dB)");
xlim([0 Fs]);

figure(5);
ruido2 = rand(1,221496); %Generamos el segundo ruido aleatorio de 0.05 Max
ruido2 = ruido2/20; %Amplitud de 0.05 max
frec_ruido2 = fft(ruido2); %Frecuencias del ruido 2
plot(f,abs(frec_ruido2)); %Grafica de Frecuencias del Ruido 2
title("Frecuencias Ruido 2");
xlabel("Frecuencia (Hz)"); ylabel("Amplitud (dB)");
xlim([0 Fs]);
ylim([0 50]);

yruido = y + ruido1 + ruido2; %Audio final con ambos ruidos
figure(9)
frec_ruidototal = fft(yruido);
plot(f,abs(frec_ruidototal));
title("Frecuencias del Audio Con Ruido");
xlabel("Frecuencia (Hz)"); ylabel("Amplitud (dB)");
xlim([0 Fs]);

audiowrite('Sasageyo_Ruido.wav',yruido,Fs); 

%-------------------------------------------------------------------------------
%Parte 3 Diseño de Filtros IIR
[n1,d1]= butter(2,[3950 4050]/(Fs/2),'stop');
y_sinruido1 = filter(n1,d1,yruido);

figure(6)
frec_sinruido = fft(y_sinruido1); %Frecuencias de Audio sin ruido de 4000Hz
plot(f, abs(frec_sinruido)); %Grafica de Frecuencias sin primer ruido
title("Frecuencias del Audio Sin Ruido con Filtro de 4000Hz");
xlabel("Frecuencia (Hz)"); ylabel("Amplitud (dB)");
xlim([0 Fs]);
ylim([0 2000]);

[n2,d2]= butter(1,10000/(Fs/2),'low');
y_sinruido_iir = filter(n2,d2,y_sinruido1);

figure(10)
frec_sinruido_iir = fft(y_sinruido_iir); %Frecuencias de Audio Sin Ruido IIR
plot(f, abs(frec_sinruido_iir)); %Grafica de Frecuencias Sin Ruido IRR
title("Frecuencias del Audio Sin Ruido con Filtro IIR");
xlabel("Frecuencia (Hz)"); ylabel("Amplitud (dB)");
xlim([0 Fs]);
ylim([0 2000]);

audiowrite('Sasageyo_SinRuido_IIR.wav',y_sinruido_iir,Fs); 

%-------------------------------------------------------------------------------
%Parte 4 Diseño de Filtros FIR

fn = [0 0.353 0.353 0.375 0.375 0.9 0.92 0.94 0.96 0.98 1]; 
A = [1 1  0 0 1 1 0.9 0.8 0.7 0.6 0.5]; %Vector de ganancia

figure(7)
n = fir2(300,fn,A); % Filtor FIR
freqz(n,1) %Grafica del filtro

y_sinruido_fir = filter(n,1,yruido); %filtro aplicado para eliminar ruido

figure(8)
frec_fir = fft(y_sinruido_fir); %frecuencias del audio sin ruido FIR
plot(f,abs(frec_fir));
title("Frecuencias del Audio Sin Ruido con Filtro FIR");
xlabel("Frecuencia (Hz)"); ylabel("Amplitud (dB)");
xlim([0 Fs]);
ylim([0 2000]);

audiowrite('Sasageyo_SinRuido_FIR.wav',y_sinruido_fir,Fs); 

