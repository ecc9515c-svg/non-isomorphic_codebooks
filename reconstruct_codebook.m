function reconstructed_cb = reconstruct_codebook(cb_idx, map, rule_map, masks, basis_cb)
    % RECONSTRUCT_CODEBOOK Reconstructs a codebook from the generative model.
    %
    % Inputs:
    %   cb_idx   : Index of codebook to generate (1 to 8)
    %   map      : Global_Alignment_Map (259x9)
    %   rule_map : Transformation_Rule_Map (259x9)
    %   masks    : Transformation_XOR_Masks (259x9)
    %   basis_cb : Master Basis Codebook (codebook_0)
    
    target_col = cb_idx + 1; 
    reconstructed_cb = zeros(259, 16);
    
    for r = 1:259
        master_idx = map(r, target_col);
        rule = rule_map(r, target_col);
        source_row = basis_cb(master_idx, :);
        
        if rule == 0       % IDENTITY
            reconstructed_cb(r, :) = source_row;
        elseif rule == 1   % COMPLEMENT
            reconstructed_cb(r, :) = bitxor(source_row, 1);
        elseif rule == 2   % XOR
            mask_val = masks(r, target_col);
            mask_vec = de2bi(mask_val, 16, 'left-msb');
            reconstructed_cb(r, :) = bitxor(source_row, mask_vec);
        end
    end
end