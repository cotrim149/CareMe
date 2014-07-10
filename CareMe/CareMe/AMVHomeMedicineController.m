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
    UILabel *_emptyMedicinesLb;
    BOOL _showCompletedMedicines;
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
        _showCompletedMedicines = NO;

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
    
    if(_showCompletedMedicines == NO)
        [self removeCompletedMedicines];
    
    if (_medicines.count == 0) {
        self.searchBar.hidden = YES;
        self.scroll.hidden = YES;
        self.dayPeriodSC.hidden = YES;
        self.showCompletedMedicinesBt.hidden = YES;
        _editMedicineBt.enabled = NO;
        [self.view addSubview:_emptyMedicinesLb];
    } else {
        if(self.searchBar.hidden == YES) {
            self.searchBar.hidden = NO;
            self.scroll.hidden = NO;
            self.dayPeriodSC.hidden = NO;
            self.showCompletedMedicinesBt.hidden = NO;
            _editMedicineBt.enabled = YES;
            [_emptyMedicinesLb removeFromSuperview];
        }
    }
    self.searchBar.text = @"";
    
    if(self.tableViewMedicines.editing){
        [self.tableViewMedicines setEditing:NO];
        self.navigationItem.leftBarButtonItem.title=_titleLeftBarButtonEditing;
    }
    
    [self updateTable];
}

-(void)viewDidAppear:(BOOL)animated {
    if(IS_IPHONE_5 == NO) {
        CGSize iphone4Size = CGSizeMake(self.tableViewMedicines.frame.size.width, self.tableViewMedicines.frame.size.height + (568-480));
        self.scroll.contentSize = iphone4Size;
    }
}


-(void)updateTable {
    NSMutableArray *medicines = [[NSMutableArray alloc] init];
    
    DAY_PERIOD dayPeriod = (DAY_PERIOD) self.dayPeriodSC.selectedSegmentIndex;
    if(dayPeriod != ALL){
        for (AMVMedicine *medicine in _medicines) {
            
            NSDateComponents *date = [medicine startDate];
            
            AMVMedicine *medicineInPeriod = nil;
            
            if(medicine.periodType == HOUR) {
                int numberOfAlarms = (int) (24 / medicine.periodValue);
                
                for(int i = 0; i < numberOfAlarms; i++) {
                    if(medicineInPeriod != nil){
                        NSTimeInterval medicineOffset = (i*1*60*60*medicine.periodValue);
                        
                        NSDate *medicineDate = [[[NSCalendar currentCalendar] dateFromComponents:medicine.startDate] dateByAddingTimeInterval:medicineOffset];
                        NSCalendar *cal = [NSCalendar currentCalendar];
                        NSDateComponents *medicineDateComponents = [cal components:
                                                                    NSYearCalendarUnit |
                                                                    NSMonthCalendarUnit |
                                                                    NSDayCalendarUnit |
                                                                    NSHourCalendarUnit |
                                                                    NSMinuteCalendarUnit
                                                                          fromDate:medicineDate];
                        
                        if([AMVCareMeUtil dayPeriodForDate:medicineDateComponents] == dayPeriod)
                            medicineInPeriod = medicine;
                    } else {
                        break;
                    }
                }
                
                if(medicineInPeriod != nil)
                    [medicines addObject:medicineInPeriod];
                
            } else if([AMVCareMeUtil dayPeriodForDate:date] == dayPeriod){
                [medicines addObject:medicine];
            }
        }
    } else {
        medicines = [[NSMutableArray alloc] initWithArray:_medicines];
    }

    _medicines = medicines;
    [self.tableViewMedicines reloadData];
}

-(IBAction)selectPeriodSegment:(id)sender{
    [self filterMedicinesArrayWithText:self.searchBar.text];
    
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
    
    int labelWidth = self.view.frame.size.width;
    int labelHeight = 20;
    _emptyMedicinesLb = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , labelWidth, labelHeight)];
    CGPoint centralizedLabel = self.view.center;
    
    if(IS_IPHONE_5)
        centralizedLabel.y -= 80;
    else
        centralizedLabel.y -= 100;
    
    _emptyMedicinesLb.alpha = 0.5;
    _emptyMedicinesLb.center = centralizedLabel;
    
    _emptyMedicinesLb.numberOfLines = 0;
    _emptyMedicinesLb.text = @"Nenhum remédio cadastrado";
    _emptyMedicinesLb.font = [UIFont boldSystemFontOfSize:20];
    _emptyMedicinesLb.textColor = [AMVCareMeUtil secondColor];
    _emptyMedicinesLb.textAlignment = NSTextAlignmentCenter;
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

-(void) removeCompletedMedicines {
    NSDate *now = [NSDate date];
    NSMutableArray *medicinesToBeDeleted = [[NSMutableArray alloc] init];
    NSMutableArray *medicines = [NSMutableArray arrayWithArray:_medicines];
    
    for(AMVMedicine *medicine in medicines) {
        NSDate *medicineDate = [[NSCalendar currentCalendar] dateFromComponents:medicine.endDate];
        if([medicineDate earlierDate:now] == medicineDate)
            [medicinesToBeDeleted addObject:medicine];
    }
    
    [medicines removeObjectsInArray:medicinesToBeDeleted];
    
    _medicines = medicines;
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
                msg = @"Remédio foi adicionado aos lembretes!";
                break;
            case UPDATE_EVENT:
                msg = @"Remédio foi atualizado dos lembretes!";
                break;
            case DELETE_EVENT:
                msg = @"Remédio foi removido dos lembretes!";
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
        [self.tableViewMedicines endUpdates];
        
        [self updateTable];
        
        if([self.tableViewMedicines numberOfRowsInSection:0] == 0){
            self.navigationItem.leftBarButtonItem.title = _titleLeftBarButtonEditing;
            [self.tableViewMedicines setEditing:NO animated:YES];
        }
        
        if([_dao listMedicines].count == 0) {
            self.searchBar.hidden = YES;
            self.scroll.hidden = YES;
            self.dayPeriodSC.hidden = YES;
            self.showCompletedMedicinesBt.hidden = YES;
            _editMedicineBt.enabled = NO;
            [self.view addSubview:_emptyMedicinesLb];
        }
    }
    
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    [self filterMedicinesArrayWithText:text];
    
    [self updateTable];
}

-(void) filterMedicinesArrayWithText:(NSString*) text {
    if(text.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",text];
        
        NSArray *unfiltredMedicines = [_dao listMedicines];
        
        _medicines = [unfiltredMedicines filteredArrayUsingPredicate:predicate];
        
    } else {
        _medicines = [_dao listMedicines];
    }
    
    if(_showCompletedMedicines == NO)
        [self removeCompletedMedicines];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    [self filterMedicinesArrayWithText:self.searchBar.text];
    [self updateTable];
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    static short cancelButtonDiff = 15;
    
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
            subView.frame = CGRectMake(subView.frame.origin.x - cancelButtonDiff, subView.frame.origin.y, subView.frame.size.width + cancelButtonDiff, subView.frame.size.height);
        } else if([subView isKindOfClass:NSClassFromString(@"UITextField")]) {
            subView.frame = CGRectMake(subView.frame.origin.x, subView.frame.origin.y, subView.frame.size.width - cancelButtonDiff, subView.frame.size.height);
        }
    }
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}
- (IBAction)dismissKeyboard:(id)sender {
    [sender endEditing: YES];
}

- (IBAction)showHideCompletedMedicines:(id)sender {
    if(_showCompletedMedicines == NO) {
        _showCompletedMedicines = YES;
        [_showCompletedMedicinesBt setTitle:@"Ocultar Concluídos" forState:UIControlStateNormal];
    } else {
        _showCompletedMedicines = NO;
        [_showCompletedMedicinesBt setTitle:@"Mostrar Concluídos" forState:UIControlStateNormal];
    }
    
    [self filterMedicinesArrayWithText:self.searchBar.text];
    [self updateTable];
}

@end
