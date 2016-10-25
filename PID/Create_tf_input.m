%User enter the poles
pole1 = input('User enter the pole 1: ');
pole2 = input('User enter the pole 2: ');
gain = input('User enter the gain : ');
%Define the desire transfer function
tss =  input('User enter the settling time tss: ');
Mp =  input('User enter the Maximun peak for the function: 1>Mp>0 ');



%function f = pid(pole1, pole2 , gain, tss, Mp)


    %define the zeros, poles and gain  
    zeros = [];     
    polos = [pole1 pole2];
    [nums,dens] = zp2tf(zeros,polos,gain);

    %Get some parameters  for create the transfer function 
    Wn = sqrt(dens(3)); %check is the pos 3 exist
    K = nums(3) ;
    Z =  dens(2) / (2 * Wn); 

    %Create the transfer function based on the parameters
    num = [K*(Wn^2)];
    den = [1 2*Z*Wn Wn^2];
    Gs = tf(num,den)
    step(Gs)
    grid on


    Kd = 1;
    Zd = abs(log(Mp)) /  sqrt ( pi^2 + log(Mp)^2);
    Wnd =  4 / (Zd*tss);
    numd = [Kd*(Wnd^2)];
    dend = [1 2*Zd*Wnd Wnd^2];
    Gd = tf(numd,dend)

    hold on
    step(Gd)
    
    %Calc the transfer function
    %based on the dominant pole 
    dominant_pole =-5*max(real(roots(dend)));
    Gnd = tf([dominant_pole],[1 dominant_pole])

    %Now the multiplication of the transfer 
    %functions for could compare among the functions
    Gd3 = series(Gd, Gnd)

    %Create another figure
    figure(2)
    step(Gd)
    grid on 
    hold on
    step(Gd3)

    
    %Now the values of the PID
    Kd = (Gd3.den{1}(2)- Gs.den{1}(2)) / Gs.num{1}(3);
    Kp = (Gd3.den{1}(3)-  Gs.den{1}(3)) / Gs.num{1}(3);
    Ki = Gd3.den{1}(4) / Gs.num{1}(3);
    
    Cs = tf([Kd Kp Ki], [1 0])
     %Now get the desire function
    Glc = feedback(series(Gs, Cs), 1)
    step(Glc)

%end 


