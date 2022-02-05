 function psnr_value=psnr(x,y)


      max_value=max(max(x(:)),max(y(:))); 
  
  
  if max_value>2
  
      max_value=255;
      
  else
      max_value=1;
      
  end
  
    
    psnr_value = 10*log10(max_value.^2/mean((x(:)-y(:)).^2));

  
  
  








