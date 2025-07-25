%B1:
mau_rgb=imread('tudien.jpg');
mau=rgb2gray(mau_rgb);
[M N]=size(mau);
maux2=zeros(2*M,2*N);
maux2(1:M,1:N)=mau;
mau_b1=uint8(maux2);%Dong nay khong quan trong
%B2:
[P Q]=size(maux2);
for i=1:P
    for j=1:Q
        maux2(i,j)=maux2(i,j)*(-1)^(i+j);
    end
end
mau_b2=uint8(maux2);%Dong nay khong quan trong
%B3:
m3=zeros(P,Q);
for y=1:Q
    for u=0:P-1
        sum=0;
       for x=0:P-1
           k=exp( 1i*(-2*pi)*(u*x/P));
           sum=sum+maux2(x+1,y)*k;
       end
        m3(u+1,y)=sum;
    end
end
m4=zeros(P,Q);
for u=1:P
    for v=0:Q-1
        sum=0;
        for y=0:Q-1
            k=exp( 1i*(-2*pi)*(v*y/Q));
             sum=sum+m3(u,y+1)*k;
           
        end
        m4(u,v+1)=sum;
    end
end
%B4:
H=zeros(P,Q);
uo=P/2;
vo=Q/2;
Do=10;
for u=1:P
    for v=1:Q
        D=sqrt((u-uo)^2+(v-vo)^2);
H(u,v)=1-exp(-D^2/(2*Do^2));
    end
end
%B5:
f_loc=m4.*H;
%B6.1:
m5=zeros(P,Q);
for u=1:P
    for y=0:Q-1
        sum=0;
        for v=0:Q-1
            k=exp(1i*2*pi*(v*y/Q));
            sum=sum+f_loc(u,v+1)*k;
        end
        m5(u,y+1)=sum;
    end
end
m6=zeros(P,Q);
for y=1:Q
    for x=0:P-1
        sum=0;
        for u=0:P-1
            k=exp(1i*2*pi*(u*x/P));
            sum=sum+m5(u+1,y)*k;
        end
        m6(x+1,y)=sum;
    end  
end
m6=m6*1/(P*Q);
m7=log(abs(m6)+1);%Dong nay khong quan trong
m6=real(m6);


%B6.2:
for i=1:P
    for j=1:Q
        m6(i,j)=m6(i,j)*(-1)^(i+j);
    end
end
m8=m6;
%B7:
m6=m6(1:M,1:N);
figure
subplot(2,5,1);
imshow(mau);
title('Anh goc');
subplot(2,5,2);
imshow(mau_b1);
title('Buoc 1');
subplot(2,5,3);
imshow(mau_b2);
title('Buoc 2');
subplot(2,5,4);
imshow(log(abs(m4)+1),[]);
title('Buoc 3');
subplot(2,5,5);
imshow(log(abs(H)+1),[]);
title('Buoc 4:Bo loc H');
subplot(2,5,6)
imshow(log(abs(f_loc)+1),[]);
title('Buoc 5');
subplot(2,5,7)
imshow(m7,[]);
title('Buoc 6.1');
subplot(2,5,8)
imshow(log(abs(m8)+1),[]);
title('Buoc 6.2 ');
subplot(2,5,9)
imshow(log(abs(m6)+1),[]);
title('Buoc 7');
figure
subplot(1,2,1);
mesh(abs(m4));
title('Buoc 3: Pho tan 3D ');
subplot(1,2,2);
plot(abs(m4));
title('Pho tan 2D');



