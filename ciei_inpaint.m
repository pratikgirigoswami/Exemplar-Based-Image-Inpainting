function [ x, u, num_of_iter ] = ciei_inpaint( img,fillImg,fillRegion )

display('.......................')
disp('CIEI Method')
display('.......................')

fillColor=[0 255 0];

img = double(img);
x=img;
origImg = img;
ind = img2ind(img);
sz = [size(img,1) size(img,2)];
sourceRegion = ~fillRegion;


[Ux Uy]=gradient(img);
[Uxx Uxy]=gradient(Ux);
[Uyx Uyy]=gradient(Uy);
Ux2=Ux.^2;
Uy2=Uy.^2;
den=Ux2+Uy2;
magU=sqrt(den);
Uzz=(Uy2.*Uxx)-(2.*Ux.*Uy.*Uxy)+(Ux2.*Uyy);
Uzz=Uzz./den;
Dfull=abs(Uzz)./magU;
Dfull=sum(Dfull,3);


%% Initialize confidence and data terms
C = double(sourceRegion);
D = repmat(-.1,sz);

  fillMovie(1).cdata=uint8(img); 
  fillMovie(1).colormap=[];
  origImg(1,1,:) = fillColor;
  iter = 2;
%% Modified
tic
num_of_iter=0;

while any(fillRegion(:)) % Determine whether any array elements are nonzero
    
    num_of_iter=num_of_iter+1;
    
    B=[1,1,1;1,-8,1;1,1,1];
    dR = find(conv2(double(fillRegion),B,'same')>0); % Boundary Points
    [Nx,Ny] = gradient(double(~fillRegion)); 
    N = [Nx(dR(:)) Ny(dR(:))]; % Gradients at Boundary Points
    N = normr(N);  
    N(~isfinite(N))=0; % handle NaN and Inf

    % Compute confidences along the fill front
    for k=dR'
        Hp = getpatch(sz,k);
        q = Hp(~(fillRegion(Hp)));
        C(k) = sum(C(q))/numel(Hp); % numel : number of elements
    end
  
  % Compute patch priorities = confidence term * data term
%   D(dR) = abs(Ix(dR).*N(:,1)+Iy(dR).*N(:,2)) + 0.001;
    D(dR)=Dfull(dR);
    priorities = C(dR).* D(dR);
  
  % Find patch with maximum priority, Hp
  [unused,ndx] = max(priorities(:));
  p = dR(ndx(1));
  [Hp,rows,cols] = getpatch(sz,p);
  toFill = fillRegion(Hp);
  
   % Find exemplar that minimizes error, Hq
  Hq = bestexemplar(img,img(rows,cols,:),toFill',sourceRegion);
  
  % Update fill region
  fillRegion(Hp(toFill)) = false;
  
  % Propagate confidence & isophote values & 
  C(Hp(toFill))  = C(p);
%   Ix(Hp(toFill)) = Ix(Hq(toFill));
%   Iy(Hp(toFill)) = Iy(Hq(toFill));
  Dfull(Hp(toFill)) = Dfull(Hq(toFill));
  
  
  % Copy image data from Hq to Hp
  ind(Hp(toFill)) = ind(Hq(toFill));
  img(rows,cols,:) = ind2img(ind(rows,cols),origImg);  

    ind2 = ind;
    ind2(fillRegion) = 1;
    fillMovie(iter).cdata=uint8(ind2img(ind2,origImg)); 
    fillMovie(iter).colormap=[];
    
    
    iter = iter+1;
  
end
toc  
inpaintedImg=img;
i1=inpaintedImg;
u=i1;
i2=origImg;
i3=fillImg;
c=C;
d=D;

figure;
subplot(131);image(uint8(i2)); title('Original image');
subplot(132);image(uint8(i3)); title('Fill region');
subplot(133);image(uint8(i1)); title('Inpainted image');
figure;
imshow(uint8(i1));

% figure;
% subplot(121);imagesc(c); title('Confidence term');
% subplot(122);imagesc(d); title('Data term');

end