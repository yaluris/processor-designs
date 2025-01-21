Τα τροποποιημένα από την πρώτη εργαστηριακή άσκηση .vhd modules: IFSTAGE, EXSTAGE
IFSTAGE: αφαιρέθηκαν ο INCREMENTOR και ο ADDERIMM και αλλάξανε οι είσοδοι του MUX32bit2to1 σε IncrementedPC και Branch_Addr
EXSTAGE: προστέθηκε ο MUX32bit4to1 με εισόδους RF_B, 4, Immed και 0, αλλάξανε οι είσοδοι του MUX32bit2to1 σε PC και RF_A
και οι είσοδοι A και B της ALU συνδέθηκαν με τις εξόδους των 2 πολυπλεκτών
