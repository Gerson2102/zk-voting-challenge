use std::hash::poseidon::bn254::hash_1;
use std::hash::poseidon::bn254::hash_2;
////// Checkpoint 4 //////
use binary_merkle_root::binary_merkle_root;

fn main(
    // public inputs
    nullifier_hash: pub Field,
    // private inputs
    nullifier: Field,
    secret: Field,
    ////// Checkpoint 4 //////
    // // public inputs
    root: pub Field,
    vote: pub bool,
    depth: pub u32,
    // // private inputs
    index: Field,
    siblings: [Field; 16],
) {
    ////// Checkpoint 3 //////
    assert(nullifier_hash == hash_1([nullifier]));

    let commitment = hash_2([nullifier, secret]);

    ////// Checkpoint 4 //////

    let mut siblings_num: u32 = 0;
    for i in 0..16 {
        if siblings[i] != 0 {
            siblings_num += 1;
        }
    }

    assert(depth <= siblings.len());

    let le_bits_index = index.to_le_bits();

    let computed_root =
        binary_merkle_root(hash_2, commitment, siblings_num, le_bits_index, siblings);
    assert(root == computed_root);

    let vote_field: Field = vote as Field;
    assert((vote_field * vote_field) == vote_field);
}
