function ind = img2ind(img)
s=size(img);
ind=reshape(1:s(1)*s(2),s(1),s(2)); % indices in verticle manner