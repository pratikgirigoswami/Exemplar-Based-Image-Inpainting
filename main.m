clc;
close all;
clear all;

display('.....Choose Method.....')
display('.......................')
display('1. Criminisi')
display('2. CIEI')
display('3. p-Laplace')
display('4. Proposed (ISEF based)')
display('.......................')

method  =   input('Enter your choice for method : ');

display('.....Choose Image.....')
display('.......................')
display('1. Structure + Texture')
display('2. Bungee')
display('3. Kids')
display('4. Lena')
display('5. Shoes')
display('6. Pratik')
display('7. Horse')
display('.......................')

user_image = input('Enter your choice of image : ');

display('.......................')

if     user_image==1
    [img,fillImg,fillRegion] = loadimgs('test0.png','test1.png',[255 0 0]);
elseif user_image==2
    [img,fillImg,fillRegion] = loadimgs('bungee0.png','bungee1.png',[0 255 0]);
elseif user_image==3
    [img,fillImg,fillRegion] = loadimgs('kids0.png','kids1.png',[0 255 0]);
elseif user_image==4
    [img,fillImg,fillRegion] = loadimgs('lena0.png','lena1.png',[0 255 0]);
elseif user_image==5
    [img,fillImg,fillRegion] = loadimgs('shoes0.png','shoes1.png',[255 0 0]);
elseif user_image==6
    [img,fillImg,fillRegion] = loadimgs('me0.png','me1.png',[0 0 255]);
elseif user_image==7
    [img,fillImg,fillRegion] = loadimgs('horse0.png','horse1.png',[255 0 0]);
else
    display('%...Invalid input...%')
end

if method == 1
    [ x,u, num_of_iter ] = criminisi_inpaint( img,fillImg,fillRegion );
elseif method == 2
    [ x,u, num_of_iter ] = ciei_inpaint( img,fillImg,fillRegion );
elseif method == 3
    [ x,u, num_of_iter ] = plaplace_inpaint( img,fillImg,fillRegion );
elseif method == 4
    [ x,u, num_of_iter ] = isef_inpaint( img,fillImg,fillRegion );
end


display('.......................')
disp('Number of iterations')
disp(num_of_iter)

if (user_image==1) || (user_image==3) || (user_image==4)

display('.......................')
val_psnr=psnr(x,u);
disp('PSNR :')
disp(val_psnr)

display('.......................')
[mssim3, ssim_map] = ssim(x(:,:,3), u(:,:,3));
[mssim2, ssim_map] = ssim(x(:,:,2), u(:,:,2));
[mssim1, ssim_map] = ssim(x(:,:,1), u(:,:,1));
mssim=(mssim1+mssim2+mssim3)/3;
disp('SSIM :')
disp(mssim)

display('.......................')
[FSIM3, FSIMc3]=FeatureSIM(x(:,:,3), u(:,:,3));
[FSIM2, FSIMc2]=FeatureSIM(x(:,:,2), u(:,:,2));
[FSIM1, FSIMc1]=FeatureSIM(x(:,:,1), u(:,:,1));
FSIM=(FSIM1+FSIM2+FSIM3)/3;
FSIMc=(FSIMc1+FSIMc2+FSIMc3)/3;
disp('FSIM :')
disp(FSIMc)

end
