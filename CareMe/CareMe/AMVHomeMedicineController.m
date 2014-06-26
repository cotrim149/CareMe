//
//  AMVHomeMedicineController.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVHomeMedicineController.h"
#import "AMVEventsManagerSingleton.h"

@interface AMVHomeMedicineController (){
    AMVMedicineDAO *_dao;
    NSArray *_medicines;
    AMVEventsManagerSingleton *_eventsManager;
    UIBarButtonItem *_editMedicineBt;
}

@end

@implementation AMVHomeMedicineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *consultItem = [[UITabBarItem alloc] initWithTitle:@"Remédios"
                                                                  image:[UIImage imageNamed:@"Medicine.png"]
                                                          selectedImage:[UIImage imageNamed:@"Medicine.png"]];
        self.tabBarItem=consultItem;
        
        _dao = [[AMVMedicineDAO alloc]init];
        _eventsManager = [AMVEventsManagerSingleton getInstance];
        _titleLeftBarButtonEditing = @"Editar";
        _titleLeftBarButtonOK = @"OK";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addComponentsAndConfigureStyle];
}

-(void)viewWillAppear:(BOOL)animated {
    _medicines = [_dao listMedicines];
    
    if (_medicines.count == 0) {
        self.searchBar.hidden = YES;
        self.scroll.hidden = YES;
        self.dayPeriodSC.hidden = YES;
        _editMedicineBt.enabled = NO;
    } else {
        if(self.searchBar.hidden == YES) {
            self.searchBar.hidden = NO;
            self.scroll.hidden = NO;
            self.dayPeriodSC.hidden = NO;
            _editMedicineBt.enabled = YES;
        }
    }
    self.searchBar.text = @"";
    
    
    if(self.tableViewMedicines.editing){
        [self.tableViewMedicines setEditing:NO];
        self.navigationItem.leftBarButtonItem.title=_titleLeftBarButtonEditing;
    }
    [self updateTable];
}

-(void)updateTable{
    NSMutableArray *medicines = [[NSMutableArray alloc] init];
    
    if(self.dayPeriodSC.selectedSegmentIndex == 0){
        for (AMVMedicine *medicine in _medicines) {
            
            NSDateComponents *date = [medicine startDate];
            
            if([AMVCareMeUtil dayPeriodForDate:date] == MORNING){
                [medicines addObject:medicine];
            }
        }
        
        _medicines = medicines;
        [self.tableViewMedicines reloadData];
    }

    if(self.dayPeriodSC.selectedSegmentIndex == 1){
        for (AMVMedicine *medicine in _medicines) {
            
            NSDateComponents *date = [medicine startDate];
            
            if([AMVCareMeUtil dayPeriodForDate:date] == AFTERNOON){
                [medicines addObject:medicine];
            }
        }
        
        _medicines = medicines;
        [self.tableViewMedicines reloadData];
    }
    if(self.dayPeriodSC.selectedSegmentIndex == 2){
        for (AMVMedicine *medicine in _medicines) {
            
            NSDateComponents *date = [medicine startDate];
            
            if([AMVCareMeUtil dayPeriodForDate:date] == NIGHT){
                [medicines addObject:medicine];
            }
        }
        
        _medicines = medicines;
        [self.tableViewMedicines reloadData];
    }
    if(self.dayPeriodSC.selectedSegmentIndex == 3){
        [self.tableViewMedicines reloadData];
    }


}
-(IBAction)selectPeriodSegment:(id)sender{
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];

    [self updateTable];

}
-(void) addComponentsAndConfigureStyle {
    self.title=@"Remédios";
    
    UIBarButtonItem *addMedicineBt = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addMedicine)
                                     ];
    addMedicineBt.tintColor = [AMVCareMeUtil secondColor];
    
    self.navigationItem.rightBarButtonItem=addMedicineBt;
    
     _editMedicineBt = [[UIBarButtonItem alloc]
                                      initWithTitle:_titleLeftBarButtonEditing
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(editMedicine)];
    
    self.navigationItem.leftBarButtonItem = _editMedicineBt;

    
    self.dayPeriodSC.tintColor = [AMVCareMeUtil firstColor];
    [self.dayPeriodSC setTitle:@"Manhã" forSegmentAtIndex:0];
    [self.dayPeriodSC setTitle:@"Tarde" forSegmentAtIndex:1];
    [self.dayPeriodSC setTitle:@"Noite" forSegmentAtIndex:2];
    [self.dayPeriodSC setTitle:@"Todos" forSegmentAtIndex:3];
    
    self.dayPeriodSC.selectedSegmentIndex = (int) [AMVCareMeUtil dayPeriodNow];
    
    self.searchBar.tintColor = [AMVCareMeUtil secondColor];
    [self.searchBar setBackgroundImage:[AMVCareMeUtil imageWithColor:[AMVCareMeUtil firstColor]]];
}


-(void) addMedicine {
    [self.navigationController pushViewController:[[AMVAddMedicineController alloc] init] animated:YES];
}

-(void) editMedicine{
    
    if([self.tableViewMedicines numberOfRowsInSection:0] > 0){
        if(self.tableViewMedicines.editing){
            [self.tableViewMedicines setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem.title = _titleLeftBarButtonEditing;
            
        }else{
            [self.tableViewMedicines setEditing:YES animated:YES];
            self.navigationItem.leftBarButtonItem.title = _titleLeftBarButtonOK;
            self.tableViewMedicines.allowsSelectionDuringEditing = YES;
            
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_medicines count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Cria a célula desta linha da tabela
    NSString *cellIdentifier = @"AMVMedicineCell";
    AMVMedicineCell *cell = (AMVMedicineCell *)[self.tableViewMedicines dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AMVMedicineCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //Numero da linha
    NSInteger linha = indexPath.row;
    
    AMVMedicine *medicine = [_medicines objectAtIndex:linha];
    
    [cell fillWithMedicine:medicine];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView cellForRowAtIndexPath:indexPath].editing){
        AMVAddMedicineController *medicineController = [[AMVAddMedicineController alloc] init];
        
        AMVMedicine *medicine = [_medicines objectAtIndex:indexPath.row];
        
        medicineController.medicineToBeEdited = medicine;
        
        [self.navigationController pushViewController:medicineController animated:YES];
        
    }else {
        NSInteger linha = indexPath.row;
        
        AMVMedicine *medicine = [_medicines objectAtIndex:linha];
        
        AMVMedicineDetailsViewController *medicineDetails = [[AMVMedicineDetailsViewController alloc]init];
        
        medicineDetails.medicine = medicine;
        
        [self.navigationController pushViewController:medicineDetails animated:YES];
        
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)notifyMedicineReminderResult:(BOOL)result manipulationType:(AMVManipulationType)manipulationType {
    NSString *msg = nil;
    if(result == YES) {
        switch (manipulationType) {
            case CREATE_EVENT:
                msg = @"Medicamento foi adicionado aos lembretes!";
                break;
            case UPDATE_EVENT:
                msg = @"Medicamento foi atualizado dos lembretes!";
                break;
            case DELETE_EVENT:
                msg = @"Medicamento foi removido dos lembretes!";
                break;
                
            default:
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alerta!"
                              message:msg
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alerta!"
                              message:@"Não foi possível acessar os seus lembretes. Verifique as permissões do app."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        AMVMedicine *medicineToBeDeleted = [_medicines objectAtIndex:indexPath.row];
        
        if(medicineToBeDeleted.reminderId != nil) {
            NSString *reminderId = [_eventsManager manipulateMedicineReminder:medicineToBeDeleted withAlarm:NO manipulationType:DELETE_EVENT];
            [self notifyMedicineReminderResult:(reminderId != nil) manipulationType:DELETE_EVENT];
        }
        
        [_dao deleteMedicine: medicineToBeDeleted];
        NSMutableArray *medicineListWithoutDeleted = [[NSMutableArray alloc] initWithArray:_medicines];
        [medicineListWithoutDeleted removeObjectAtIndex:indexPath.row];
        _medicines = medicineListWithoutDeleted;
        
        
        NSArray *medicines = [NSArray arrayWithObjects:indexPath, nil];
        
        [self.tableViewMedicines beginUpdates];
        [self.tableViewMedicines deleteRowsAtIndexPaths:medicines withRowAnimation:UITableViewRowAnimationFade];
        [self.tableViewMedicines insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableViewMedicines endUpdates];
        
        [self updateTable];
        
        if([self.tableViewMedicines numberOfRowsInSection:0] == 0){
            self.navigationItem.leftBarButtonItem.title = _titleLeftBarButtonEditing;
        }
        
    }
    
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    if(text.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",text];
        
        NSArray *unfiltredMedicines = [_dao listMedicines];
        
        _medicines = [unfiltredMedicines filteredArrayUsingPredicate:predicate];
        
    } else {
        _medicines = [_dao listMedicines];
    }
    
    [self updateTable];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    _medicines = [_dao listMedicines];
    [self updateTable];
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}
- (IBAction)dismissKeyboard:(id)sender {
    [sender endEditing: YES];
}



@end
