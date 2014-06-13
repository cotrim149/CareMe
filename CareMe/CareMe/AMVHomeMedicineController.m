//
//  AMVHomeMedicineController.m
//  CareMe
//
//  Created by Matheus Fonseca on 02/06/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVHomeMedicineController.h"

@interface AMVHomeMedicineController (){
    AMVMedicineDAO *_dao;
    NSArray *_medicines;
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
    
    [self.tableViewMedicines reloadData];
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
    
    UIBarButtonItem *editMedicineBt = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Editar"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(editMedicine)];
    
    self.navigationItem.leftBarButtonItem = editMedicineBt;

    
    self.dayPeriodSC.tintColor = [AMVCareMeUtil firstColor];
    [self.dayPeriodSC setTitle:@"Manhã" forSegmentAtIndex:0];
    [self.dayPeriodSC setTitle:@"Tarde" forSegmentAtIndex:1];
    [self.dayPeriodSC setTitle:@"Noite" forSegmentAtIndex:2];
    [self.dayPeriodSC setTitle:@"Todos" forSegmentAtIndex:3];
    
    self.dayPeriodSC.selectedSegmentIndex = (int) [AMVCareMeUtil dayPeriodNow];
}


-(void) addMedicine {
    [self.navigationController pushViewController:[[AMVAddMedicineController alloc] init] animated:YES];
}

-(void) editMedicine{
    
    if([self.tableViewMedicines numberOfRowsInSection:0] > 0){
        if(self.tableViewMedicines.editing){
            [self.tableViewMedicines setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem.title = @"Editar";
            
        }else{
            [self.tableViewMedicines setEditing:YES animated:YES];
            self.navigationItem.leftBarButtonItem.title = @"OK";
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

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if(editingStyle == UITableViewCellEditingStyleDelete){
//        
//        [_dao deleteConsult: [[_dao listConsults] objectAtIndex:indexPath.row]];
//        
//        NSArray *consulta = [NSArray arrayWithObjects:indexPath, nil];
//        
//        [self.tableViewMedicines beginUpdates];
//        
//        [self.tableViewMedicines deleteRowsAtIndexPaths:consulta withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableViewMedicines insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableViewMedicines endUpdates];
//        
//        //[self updateTable];
//        
//        if([self.tableViewMedicines numberOfRowsInSection:0] == 0){
//            self.navigationItem.leftBarButtonItem.title = @"Editar";
//        }
//        
//    }
//    
//}

@end
