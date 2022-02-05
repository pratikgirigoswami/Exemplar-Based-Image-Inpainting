function [ x, u, num_of_iter ] = ciei_inpaint( img,fillImg,fillRegion )

display('.......................')
disp('ISEF Method')
display('.......................')

img = double(img);
x=img;
origImg = img;
ind = img2ind(img);
sz = [size(img,1) size(img,2)];
sourceRegion = ~fillRegion;

fillColor=[0 255 0];
%% Initialize confidence and data terms

C = double(sourceRegion);
D = repmat(-.1,sz);

  fillMovie(1).cdata=uint8(img); 
  fillMovie(1).colormap=[];
  origImg(1,1,:) = fillColor;
  iter = 2;

%% ISEF Edges

D3=isef((img(:,:,3)));
D2=isef((img(:,:,2)));
D1=isef((img(:,:,1)));

imgISEF=(D1+D2+D3)/(3*255);
figure;
imshow((imgISEF))

%% Modified
tic

num_of_iter=0;
while any(fillRegion(:)) % Determine whether any array elements are nonzero
    
    num_of_iter=num_of_iter+1;
    B=[1,1,1;1,-8,1;1,1,1];
    dR = find(conv2(double(fillRegion),B,'same')>0); % Boundary Points

    % Compute confidences along the fill front
    for k=dR'
        Hp = getpatch(sz,k);
        q = Hp(~(fillRegion(Hp)));
        C(k) = sum(C(q))/numel(Hp); % numel : number of elements
    end
  
    % Compute Data Term using ISEF edges
    
    D(dR)=abs(imgISEF(dR));
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
  
    % Propagate confidence & ISEF values
    C(Hp(toFill))  = C(p);
    imgISEF(Hp(toFill)) = imgISEF(Hq(toFill));
  
  
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