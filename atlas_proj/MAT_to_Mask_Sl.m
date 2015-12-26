function mask = MAT_to_Mask_Sl(myinfotosave,nslice)
% MAT_to_Mask_Slice(myinfotosave,nslice)
% 
% This function helps me to convert ROIs created in IPP to masks for a given slice number
% 
% Inputs:
% myinfotosave - The IPP structure with the ROIs.
% nslice       - Scalar indicating the slice number.
%
% Outputs:
% mask         - 2D array with the binary mask of slice "nslice".
% 

% 

% Check if we are dealing with and old S3 mat file
if ~isfield(myinfotosave,'IPPversion') % Means it was created with S3 so the y coordinates are inverted. We had only fields for opened splines
    for nspline=1:myinfotosave.dataperslice{nslice}.nsplines
        myinfotosave.dataperslice{nslice}.ycoordinatesspl{nspline} = myinfotosave.w1-myinfotosave.dataperslice{nslice}.ycoordinatesspl{nspline}+1;
    end
end
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% Check for possibility of old MAT files that have only fields for opened splines
if ~isfield(myinfotosave.dataperslice{nslice},'ncsplines')
    myinfotosave.dataperslice{nslice}.ncsplines = 0;
    myinfotosave.dataperslice{nslice}.xcoordinatescspl = cell(1,1);
    myinfotosave.dataperslice{nslice}.ycoordinatescspl = cell(1,1);
end
if ~isfield(myinfotosave.dataperslice{nslice},'nboxes')
    myinfotosave.dataperslice{nslice}.nboxes = 0;
    myinfotosave.dataperslice{nslice}.xcoordinatesb = cell(1,1);
    myinfotosave.dataperslice{nslice}.ycoordinatesb = cell(1,1);
end
if ~isfield(myinfotosave.dataperslice{nslice},'ncircles')
    myinfotosave.dataperslice{nslice}.ncircles = 0;
    myinfotosave.dataperslice{nslice}.xcentres = cell(1,1);
    myinfotosave.dataperslice{nslice}.ycentres = cell(1,1);
    myinfotosave.dataperslice{nslice}.radii = cell(1,1);
end
if ~isfield(myinfotosave.dataperslice{nslice},'nmasks')
    myinfotosave.dataperslice{nslice}.nmasks = 0;
    myinfotosave.dataperslice{nslice}.xcoordinates = cell(1,1);
    myinfotosave.dataperslice{nslice}.ycoordinates = cell(1,1);
end
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% Prepare the return variable
mask = zeros(myinfotosave.w1,myinfotosave.w2);
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% Get 2D coordinates for circle ROIs
[xs ys] = meshgrid(1:myinfotosave.w2,1:myinfotosave.w1);
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
% Do opened splines 
for nspline=1:myinfotosave.dataperslice{nslice}.nsplines
    if (myinfotosave.dataperslice{nslice}.iscartilagesegmented & mod(nspline,2)) |  myinfotosave.dataperslice{nslice}.iscartilagesegmented==0        
        tempxy = [];
    end
    tempx = myinfotosave.dataperslice{nslice}.xcoordinatesspl{nspline};
    tempy = myinfotosave.dataperslice{nslice}.ycoordinatesspl{nspline};
    ctempxy = bezieruniformsampling([tempx tempy ones(size(tempx))],myinfotosave.deltax);    
    if myinfotosave.dataperslice{nslice}.iscartilagesegmented & ~mod(nspline,2)
        tempxy = [tempxy; flipdim(ctempxy,1)];
    else
        tempxy = [tempxy; ctempxy];
    end
    %tempxy(:,1) --> Corresponds to column numbers     
    if (myinfotosave.dataperslice{nslice}.iscartilagesegmented & ~mod(nspline,2)) |  myinfotosave.dataperslice{nslice}.iscartilagesegmented==0 
        cmask = poly2mask(tempxy(:,1),tempxy(:,2),myinfotosave.w1,myinfotosave.w2);
        mask = mask | cmask;
    end 
end % End of loop of splines 
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
% Do closed splines 
for ncspline=1:myinfotosave.dataperslice{nslice}.ncsplines
    tempx = myinfotosave.dataperslice{nslice}.xcoordinatescspl{ncspline};
    tempy = myinfotosave.dataperslice{nslice}.ycoordinatescspl{ncspline};
    tempxy = bezieruniformsampling([tempx tempy ones(size(tempx))],myinfotosave.deltax);   
    cmask = poly2mask(tempxy(:,1),tempxy(:,2),myinfotosave.w1,myinfotosave.w2);
    mask = mask | cmask;
end
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
% Do boxes 
for nbox=1:myinfotosave.dataperslice{nslice}.nboxes
    ptsx = myinfotosave.dataperslice{nslice}.xcoordinatesb{nbox};
    ptsy = myinfotosave.dataperslice{nslice}.ycoordinatesb{nbox};
    side_top = bezier([ptsx(1:2) ptsy(1:2) zeros(2,1)]);
    side_right = bezier([ptsx(2:3) ptsy(2:3) zeros(2,1)]);
    side_bot = bezier([ptsx(3:4) ptsy(3:4) zeros(2,1)]);
    side_left = bezier([ptsx(4:5) ptsy(4:5) zeros(2,1)]);
    tempxy = [side_top; side_right; side_bot; side_left];
    cmask = poly2mask(tempxy(:,1),tempxy(:,2),myinfotosave.w1,myinfotosave.w2); 
    mask = mask | cmask;
end
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
% Do circles 
for ncircle=1:myinfotosave.dataperslice{nslice}.ncircles
    cx = myinfotosave.dataperslice{nslice}.xcentres{ncircle};
    cy = myinfotosave.dataperslice{nslice}.ycentres{ncircle};
    r = myinfotosave.dataperslice{nslice}.radii{ncircle};
    dists2cxy = sqrt((ys-cy).^2+(xs-cx).^2);
    cmask = zeros(myinfotosave.w1,myinfotosave.w2); 
    cmask(dists2cxy<=r) = 1;  
    mask = mask | cmask;
end
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
% Do mat masks 
for nmask=1:myinfotosave.dataperslice{nslice}.nmasks
    cmask = zeros(myinfotosave.w1,myinfotosave.w2); 
    tempx = myinfotosave.dataperslice{nslice}.xcoordinates{nmask};
    tempy = myinfotosave.dataperslice{nslice}.ycoordinates{nmask};
    pos = sub2ind([myinfotosave.w1 myinfotosave.w2],tempy,tempx);  
    cmask(pos) = 1;  
    mask = mask | cmask;
end
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

