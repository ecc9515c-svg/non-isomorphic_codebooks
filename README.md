
This repository contains the source code and data files for the structural reconstruction of an ensemble of (16, 259, 5) codebooks. Instead of storing independent matrices, this project can utilize a **Generative Model** to reconstruct any codebook in the ensemble from a single Master Basis Codebook (C_0) and a sparse Transformation Tensor. The ensemble of codebooks exhibits structural isomorphism.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
| File Name | Description | Role |

| `Codebook_0.csv` | The Master Basis Matrix | Basis (C_0) |

| `Global_Alignment_Map.csv` | Pointer indices | Index Mapping (M) |

| `Transformation_Rule_Map.csv` | The Rule Map | Tensor Rule (T) |

| `Transformation_XOR_Masks.csv` | The XOR Mask Table | Translation Data (U) |
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Quick Start
To reconstruct any codebook, use the provided "reconstruct_codebook.m" MATLAB function. 

Ensure all CSV files are in your MATLAB path or the `/data` folder.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MATLAB COMMANDS

% 1. Load the required components

Basis_CB   = readmatrix('data/Codebook_0.csv');

Map           = readmatrix('data/Global_Alignment_Map.csv');

Rule_Map   = readmatrix('data/Transformation_Rule_Map.csv');

Masks        = readmatrix('data/Transformation_XOR_Masks.csv');


% 2. Reconstruct Codebook 5

CB5 = reconstruct_codebook(5, Map, Rule_Map, Masks, Basis_CB);


% 3. Verify and Display

disp('First 5 rows of Reconstructed Codebook 5:');

disp(CB5(1:5, :));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


## Additional Reference

%% Although the MATLAB function (reconstruct_codebook.m) is already saved in repository, but is again listed below as ready reference:

function reconstructed_cb = reconstruct_codebook(cb_idx, map, rule_map, masks, basis_cb)
    % cb_idx: 1 to 8
    % map: Global_Alignment_Map
    % rule_map: Transformation_Rule_Map
    % masks: Transformation_XOR_Masks
    % basis_cb: Codebook_0
    
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
