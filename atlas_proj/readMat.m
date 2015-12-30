 %%  IPP splineto binary Mask   
path = 'gold_standard/ACL007_120223_E4630_CUBE_trans_ipsi_MFC_VPHighRes_ACL007_120223_E4630_T1p_ipsi_e1_ACL007_120223_E4630_CUBE_ipsi.mat'
load(path)
 Mask = zeros(myinfotosave.w1,myinfotosave.w2,myinfotosave.w3);
 for nslice = 1:myinfotosave.w3
        if myinfotosave.dataperslice{nslice}.nsplines
            Mask(:,:,nslice) = MAT_to_Mask_Sl(myinfotosave,nslice); % dicom and Int2 Are inverted
            imagesc(Mask(:,:,nslice))
            pause(0.01)
        end
  end