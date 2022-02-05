function [ laim1 ] = isef( in_image)


im1=in_image;
bisef=0.7;
[row col]=size(im1);
yrd=zeros(row,col);
yld=zeros(row,col);
D1=zeros(row,col);
D2=zeros(row,col);

%% Recursion in right direction %%
for i=1:row
    for j=col-1:-1:1
        yrd(i,j)=(1-bisef)*im1(i,j)+bisef*yrd(i,j+1);
    end
end
%% Recursion in left direction %%
for i=1:row
    for j=2:col
        yld(i,j)=(1-bisef)*im1(i,j)+bisef*yld(i,j-1);
    end
end
%% First order derivative %%
for i=1:row
    for j=3:col-2
        D1(i,j)=yrd(i,j+1)-yld(i,j-1);
    end
end
%% Second order derivative %%
for i=1:row
    for j=3:col-2
        D2(i,j)=yrd(i,j+1)+yrd(i,j-1)-2*im1(i,j);
    end
end 
%% Non-maxima suppression %%
    for i=1:row
    for j=2:col-1
        if ((D2(i,j)<0 & D2(i,j+1)>0) | (D2(i,j)>0 & D2(i,j+1)<0))
            if( (D1(i,j) > D1(i,j-1) & D1(i,j)>D1(i,j+1)) | (D1(i,j) < D1(i,j-1) & D1(i,j) <D1(i,j+1)))
            D4(i,j)=1;
            end
        else
            D4(i,j)=0;
        end
    end
    end
%% Thinning operation %%
st1=strel('line',3,90);
D5=imdilate(D4,st1);
% figure;
% imshow(D2);
% figure;
% imshow(D4);
% figure;imshow(D5);
% figure;imshow(D2);
laim1=D2-im1;
% figure;
% imshow(laim1);
end

