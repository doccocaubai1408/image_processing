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
figure
subplot(1,4,1);
imshow(mau);
title('Anh goc');
subplot(1,4,2);
imshow(mau_b1);
title('Buoc 1');
subplot(1,4,3);
imshow(mau_b2);
title('Buoc 2');
subplot(1,4,4);
imshow(log(abs(m4)+1),[]);
title('Buoc 3');
figure
subplot(1,2,1);
mesh(abs(m4));
title('Buoc 3: Pho tan 3D ');
subplot(1,2,2);
plot(abs(m4));
title('Pho tan 2D');