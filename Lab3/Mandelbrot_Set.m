%%%%%%%% Option to enter in x/y pixels %%%%%%%%%%%%%%%
% x_pixel_num = 50;
% y_pixel_num = 50;
% x_real = interp1([0,639],[-2,1],x_pixel_num) % 0 to 639, -2 to 1
% y_img = interp1([0,479],[-1,1],y_pixel_num) % 0 to 479, -1 to 1
% disp("x_pixel: " + x_pixel_num + " | x_real: " + x_real);
% disp("y_pixel: " + y_pixel_num + " | y_img: " + y_img);

%%%%%%%% Option to enter in real/img nums %%%%%%%%%%%%
% x_real = 0.5;
% y_img = 0.5;
% x_pixel_num = interp1([-2,1],[0,639],x_real); 
% y_pixel_num = interp1([-1,1],[0,479],y_img);
% disp("x_real: " + x_real + " | x_pixel_num: " + x_pixel_num);
% disp("y_img:  " + y_img + " | y_pixel_num: " + y_pixel_num);

% termination = 1000;
% n = 0;
% c = x_real + i*y_img;
% z = 0;
% flag = 0;
% while (abs(z)<=2 && n<termination)
%     z = z^2 + c;
%     n = n + 1;
% end
% disp("n: " + n );  
% if (abs(z)<=2) 
%     disp("z: " + z + " | In set" );   
% else
%     disp("z: " + z + " | Log_2 Iterations: " + log2(n));
% end


calc(0.5, 0.5); 
calc(0.4, 0.4);
calc(0.3, 0.3);
calc(0.2, 0.2);
calc(0.1, 0.1);
calc(0.6, 0.7);
calc(0.8, 0.9);
calc(1.1, 1.4);
calc(1.7, 1.3);
calc(2, 2);
calc(3, 3);


calc(0.31, 0.31);
calc(0.32, 0.32);
calc(0.33, 0.33);
calc(0.34, 0.34);
calc(0.35, 0.35);
calc(0.36, 0.36);
calc(0.37, 0.37);
calc(0.38, 0.38);
calc(0.39, 0.39);
calc(-1, -1);
calc(-2, -2);
calc(-3, -3);
calc(-0.9, -0.9);
calc(-0.8, -0.8);
calc(-0.7, -0.7);
calc(-0.6, -0.6);
calc(-0.5, -0.5);
calc(-0.4, -0.4);
calc(-0.3, -0.3);
calc(-0.2, -0.2);
calc(-0.1, -0.1);

function calc(x_real, y_img)
%     x_real = 0.5;
%     y_img = 0.5;
    termination = 1000;
    n = 0;
    c = x_real + i*y_img;
    z = 0;
    while (abs(z)<=2 && n<termination)
        z = z^2 + c;
        n = n + 1;
    end
    disp("x: " + x_real + "+" + y_img + "i -----" + " n: " + n ); 
end






%%%%%%%% Example code - graphs Mandelbrot Set %%%%%%%%

% clear all
% figure(1); clf;

% termination = 100;
% x = linspace(-2,1,640);
% y = linspace(-1,1,480);
% x_index = 1:length(x) ;
% y_index = 1:length(y) ;
% img = zeros(length(y),length(x));

% N_total = 0;
% for k=x_index
%     for j=y_index
%         z = 0;
%         n = 0;
%         c = x(k)+ y(j)*i ;%complex number
%         while (abs(z)<2 && n<termination)
%             z = z^2 + c;
%             n = n + 1;
%             N_total = N_total + 1;
%         end
%         n
%         img(j,k) = log2(n);
%     end
% end

% N_total
% imagesc(img)
% colormap(jet)
% right = 482;
% left = 320;
% top = 122 ;
% line ([left right],[top top],'color','k')
% line ([left right],[240+top 240+top],'color','k')
% line ([left left],[top 240+top],'color','k')
% line ([right right],[top 240+top],'color','k')
% x(right);
% x(left);
% y(top);