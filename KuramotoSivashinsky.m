function KuramotoSivashinsky()
close all;
fsz = 16; 

N = 512;
Lx = 32*pi;
x = Lx * (0:N-1)/N;
k_int = [0:(N/2), (-(N/2-1)):-1];
k = k_int * (2*pi/Lx);

u0 = cos(x/16).*(1 + sin(x/16));

dt = 0.05;  
tmax = 200;
Nt = round(tmax/dt) + 1;
t_vec = linspace(0, tmax, Nt);

U_data = zeros(Nt, N);
U_data(1,:) = u0;

L_operator_fourier = k.^2 - k.^4;
exp_L_dt = exp(dt*L_operator_fourier);

vhat = fft(u0);

for n = 1:(Nt-1)
    vhat_current = vhat;
    
    k1 = -0.5i * k .* fft((real(ifft(vhat_current))).^2);
    k2 = -0.5i * k .* fft((real(ifft(vhat_current + 0.5*dt*k1))).^2);
    k3 = -0.5i * k .* fft((real(ifft(vhat_current + 0.5*dt*k2))).^2);
    k4 = -0.5i * k .* fft((real(ifft(vhat_current + dt*k3))).^2);
    
    vhat = exp_L_dt .* (vhat_current + (dt/6)*(k1 + 2*k2 + 2*k3 + k4));
    
    U_data(n+1,:) = real(ifft(vhat));
end

figure;
imagesc(x, t_vec, U_data);
set(gca, 'YDir', 'normal');
xlabel('x','FontSize',fsz);
ylabel('time','FontSize',fsz);
title('K-S Equation','FontSize',fsz+2);
colorbar;
colormap jet;
drawnow;

saveas(gcf, 'KuramotoSivashinskyPlot.png');

end
