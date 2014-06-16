//
//  AMVHomeConsultController.m
//  CareMe
//
//  Created by Matheus Fonseca on 29/05/14.
//  Copyright (c) 2014 Alysson Matheus Victor. All rights reserved.
//

#import "AMVHomeConsultController.h"
#import "AMVAddConsultController.h"
#import "AMVCareMeUtil.h"
#import "AMVConsultDetailsViewController.h"
#import "AMVConsult.h"
#import "AMVConsultDAO.h"
#import "AMVConsultCell.h"
#import "AMVEventsManagerSingleton.h"

@interface AMVHomeConsultController () {
    AMVConsultDAO *_dao;
    NSArray *_consults;
    AMVEventsManagerSingleton *_eventsManager;
}

@end


@implementation AMVHomeConsultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *consultItem = [[UITabBarItem alloc] initWithTitle:@"Consultas"
                                                                  image:[UIImage imageNamed:@"Calendar-Month.png"]
                                                          selectedImage:[UIImage imageNamed:@"Calendar-Month.png"]];
        self.tabBarItem=consultItem;
        _eventsManager = [AMVEventsManagerSingleton getInstance];
        
        _dao = [[AMVConsultDAO alloc] init];
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

-(void) updateTable {
    NSComparator comparator = nil;
    
    AMVConsultVisualizationType visualizationType = (AMVConsultVisualizationType) self.visualizationSC.selectedSegmentIndex;
    
    switch (visualizationType) {
        case VT_DATE:
            comparator = ^NSComparisonResult(id a, id b) {
                NSDateComponents *first = ((AMVConsult*)a).date;
                NSDateComponents *second = ((AMVConsult*)b).date;
                
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                
                return [[gregorian dateFromComponents:first] compare:[gregorian dateFromComponents:second]];
            };
            break;
        case VT_SPECIALITY:
            comparator = ^NSComparisonResult(id a, id b) {
                NSString *first = ((AMVConsult*)a).doctorSpeciality;
                NSString *second = ((AMVConsult*)b).doctorSpeciality;
                
                return [[first lowercaseString] compare:[second lowercaseString]];
            };
            break;
        case VT_PLACE:
            comparator = ^NSComparisonResult(id a, id b) {
                NSString *first = ((AMVConsult*)a).place;
                NSString *second = ((AMVConsult*)b).place;
                
                return [[first lowercaseString] compare:[second lowercaseString]];
            };
            break;
    }
    
    if(comparator) {
        NSArray *unsortedConsults = [_dao listConsults];
        _consults = [unsortedConsults sortedArrayUsingComparator:comparator];
        
        [self.tableViewConsults reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateTable];
    if(self.tableViewConsults.editing){
        [self.tableViewConsults setEditing:NO];
        self.navigationItem.leftBarButtonItem.title=_titleLeftBarButtonEditing;
    }

    
}

- (IBAction)changeVisualizationType:(id)sender {
    [self updateTable];
}

-(void) addComponentsAndConfigureStyle {
    self.title=@"Consultas";
    
    UIBarButtonItem *addConsultBt = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addConsult)
                                     ];
    addConsultBt.tintColor = [AMVCareMeUtil secondColor];
    
    self.navigationItem.rightBarButtonItem=addConsultBt;
    
    UIBarButtonItem *editConsultBt = [[UIBarButtonItem alloc]
                                      initWithTitle:_titleLeftBarButtonEditing
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(editConsult)];
    
    self.navigationItem.leftBarButtonItem = editConsultBt;
     
    self.visualizationSC.tintColor = [AMVCareMeUtil firstColor];
    [self.visualizationSC setTitle:@"Data" forSegmentAtIndex:0];
    [self.visualizationSC setTitle:@"Especialidade" forSegmentAtIndex:1];
    [self.visualizationSC setTitle:@"Local" forSegmentAtIndex:2];
}

-(void) addConsult {
    AMVAddConsultController *addConsultController = [[AMVAddConsultController alloc] init];

    [self.navigationController pushViewController:addConsultController animated:YES];
}

-(void) editConsult {
    if([self.tableViewConsults numberOfRowsInSection:0] > 0){
        if(self.tableViewConsults.editing){
            [self.tableViewConsults setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem.title = _titleLeftBarButtonEditing;
            
        }else{
            [self.tableViewConsults setEditing:YES animated:YES];
            self.navigationItem.leftBarButtonItem.title = _titleLeftBarButtonOK;
            self.tableViewConsults.allowsSelectionDuringEditing = YES;
            
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_consults count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Cria a célula desta linha da tabela
    NSString *cellIdentifier = @"AMVConsultCell";
    AMVConsultCell *cell = (AMVConsultCell *)[self.tableViewConsults dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AMVConsultCell" owner:self options:nil] objectAtIndex:0];
    }

    //Numero da linha
    NSInteger linha = indexPath.row;
    
    AMVConsult *consult = [_consults objectAtIndex:linha];
    
    [cell fillWithConsult: consult];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if([tableView cellForRowAtIndexPath:indexPath].editing){
        AMVAddConsultController *consultController = [[AMVAddConsultController alloc] init];
        
        AMVConsult *consult = [_consults objectAtIndex:indexPath.row];
        
        consultController.consultToBeEdited = consult;
        NSLog(@"ID da edit = %@", consultController.consultToBeEdited.eventId);
        
        [self.navigationController pushViewController:consultController animated:YES];
    }
    else{
        NSInteger linha = indexPath.row;
        
        AMVConsult *consult = [_consults objectAtIndex:linha];
        
        AMVConsultDetailsViewController *consultDetails = [[AMVConsultDetailsViewController alloc]init];
        
        consultDetails.consult = consult;
        
        [self.navigationController pushViewController:consultDetails animated:YES];
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)notifyConsultEventResult:(BOOL)result manipulationType:(AMVManipulationType)manipulationType {
    NSString *msg = nil;
    if(result == YES) {
        switch (manipulationType) {
            case CREATE_EVENT:
                msg = @"Consulta foi adicionada aos eventos!";
                break;
            case UPDATE_EVENT:
                msg = @"Consulta foi atualizada aos aventos!";
                break;
            case DELETE_EVENT:
                msg = @"Consulta foi removida dos eventos!";
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
                              message:@"Não foi possível acessar os seus eventos. Verifique as permissões do app."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if(editingStyle == UITableViewCellEditingStyleDelete){
        AMVConsult *consultToBeDeleted = [[_dao listConsults] objectAtIndex:indexPath.row];
        
        if(consultToBeDeleted.eventId != nil) {
            NSString *eventId = [_eventsManager manipulateConsultEvent:consultToBeDeleted withAlarm:NO manipulationType:DELETE_EVENT];
            [self notifyConsultEventResult:(eventId != nil) manipulationType:DELETE_EVENT];
        }
        
        [_dao deleteConsult: consultToBeDeleted];

        NSArray *consulta = [NSArray arrayWithObjects:indexPath, nil];
       
        [self.tableViewConsults beginUpdates];
  
        [self.tableViewConsults deleteRowsAtIndexPaths:consulta withRowAnimation:UITableViewRowAnimationFade];
        [self.tableViewConsults insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableViewConsults endUpdates];
        
        [self updateTable];
        
        if([self.tableViewConsults numberOfRowsInSection:0] == 0){
            self.navigationItem.leftBarButtonItem.title = _titleLeftBarButtonEditing;
        }

    }
    
}
@end
