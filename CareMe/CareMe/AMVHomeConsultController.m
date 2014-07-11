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
    AMVEventsManagerSingleton *_eventsManager;
    UIBarButtonItem *_editConsultBt;
    UILabel *_emptyConsultsLb;
    BOOL _showCompletedConsults;
    NSArray *_consults;
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
        EDIT_TITLE = @"Editar";
        _titleLeftBarButtonOK = @"OK";
        
        _showCompletedConsults = NO;
        
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
        NSArray *unsortedConsults = _consults;
        _consults = [unsortedConsults sortedArrayUsingComparator:comparator];
        
        [self.tableViewConsults reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    _consults = [_dao listConsults];
    
    if(_showCompletedConsults == NO)
        [self removeCompletedConsults];
    
    [self updateTable];
    
    if ([_dao listConsults].count == 0) {
        self.searchBar.hidden = YES;
        self.scroll.hidden = YES;
        self.visualizationSC.hidden = YES;
        self.showCompletedConsultsBt.hidden = YES;
        _editConsultBt.enabled = NO;
        [self.view addSubview:_emptyConsultsLb];
    } else {
        if(self.searchBar.hidden == YES) {
            self.searchBar.hidden = NO;
            self.scroll.hidden = NO;
            self.visualizationSC.hidden = NO;
            _editConsultBt.enabled = YES;
            self.showCompletedConsultsBt.hidden = NO;
            [_emptyConsultsLb removeFromSuperview];
        }
    }
    self.searchBar.text = @"";
    
    if(self.tableViewConsults.editing){
        [self.tableViewConsults setEditing:NO];
        self.navigationItem.leftBarButtonItem.title=EDIT_TITLE;
    }
    
    [self updateTable];
}

-(void) removeCompletedConsults {
    NSDate *now = [NSDate date];
    NSMutableArray *consultsToBeDeleted = [[NSMutableArray alloc] init];
    NSMutableArray *consults = [NSMutableArray arrayWithArray:_consults];
    
    for(AMVConsult *consult in consults) {
        NSDate *consultDate = [[NSCalendar currentCalendar] dateFromComponents:consult.date];
        if([consultDate earlierDate:now] == consultDate)
            [consultsToBeDeleted addObject:consult];
    }
    
    [consults removeObjectsInArray:consultsToBeDeleted];
    
    _consults = consults;
}

- (IBAction)changeVisualizationType:(id)sender {
    [self updateTable];
}

-(void)viewDidAppear:(BOOL)animated {

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
    
    _editConsultBt = [[UIBarButtonItem alloc]
                                      initWithTitle:EDIT_TITLE
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(editConsult)];
    
    self.navigationItem.leftBarButtonItem = _editConsultBt;
     
    self.visualizationSC.tintColor = [AMVCareMeUtil firstColor];
    [self.visualizationSC setTitle:@"Data" forSegmentAtIndex:0];
    [self.visualizationSC setTitle:@"Especialidade" forSegmentAtIndex:1];
    [self.visualizationSC setTitle:@"Local" forSegmentAtIndex:2];
    
    self.searchBar.tintColor = [AMVCareMeUtil secondColor];
    [self.searchBar setBackgroundImage:[AMVCareMeUtil imageWithColor:[AMVCareMeUtil firstColor]]];
    
    int labelWidth = self.view.frame.size.width;
    int labelHeight = 20;
    _emptyConsultsLb = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , labelWidth, labelHeight)];
    CGPoint centralizedLabel = self.view.center;
    
    if(IS_IPHONE_5 == NO)
        centralizedLabel.y -= 60;
    
    _emptyConsultsLb.alpha = 0.5;
    _emptyConsultsLb.center = centralizedLabel;
    
    _emptyConsultsLb.numberOfLines = 0;
    _emptyConsultsLb.text = @"Nenhuma consulta cadastrada";
    _emptyConsultsLb.font = [UIFont boldSystemFontOfSize:20];
    _emptyConsultsLb.textColor = [AMVCareMeUtil secondColor];
    _emptyConsultsLb.textAlignment = NSTextAlignmentCenter;
}

-(void) addConsult {
    AMVAddConsultController *addConsultController = [[AMVAddConsultController alloc] init];

    [self.navigationController pushViewController:addConsultController animated:YES];
}

-(void) editConsult {
    if([self.tableViewConsults numberOfRowsInSection:0] > 0){
        if(self.tableViewConsults.editing){
            [self.tableViewConsults setEditing:NO animated:YES];
            self.navigationItem.leftBarButtonItem.title = EDIT_TITLE;
            self.tableViewConsults.allowsSelectionDuringEditing = NO;
        } else{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
        AMVConsult *consultToBeDeleted = [_consults objectAtIndex:indexPath.row];
        
        if(consultToBeDeleted.eventId != nil) {
            NSString *eventId = [_eventsManager manipulateConsultEvent:consultToBeDeleted withAlarm:NO manipulationType:DELETE_EVENT];
            [self notifyConsultEventResult:(eventId != nil) manipulationType:DELETE_EVENT];
        }
        
        [_dao deleteConsult: consultToBeDeleted];
        NSMutableArray *consultListWithoutDeleted = [[NSMutableArray alloc] initWithArray:_consults];
        [consultListWithoutDeleted removeObjectAtIndex:indexPath.row];
        _consults = consultListWithoutDeleted;

        NSArray *consults = [NSArray arrayWithObjects:indexPath, nil];
       
        [self.tableViewConsults beginUpdates];
        [self.tableViewConsults deleteRowsAtIndexPaths:consults withRowAnimation:UITableViewRowAnimationFade];
        [self.tableViewConsults endUpdates];
        
        if([self.tableViewConsults numberOfRowsInSection:0] == 0) {
            self.navigationItem.leftBarButtonItem.title = EDIT_TITLE;
            [self.tableViewConsults setEditing:NO animated:YES];
        }
        
        if ([_dao listConsults].count == 0) {
            self.searchBar.hidden = YES;
            self.scroll.hidden = YES;
            self.visualizationSC.hidden = YES;
            self.showCompletedConsultsBt.hidden = YES;
            _editConsultBt.enabled = NO;
            
            [self.view addSubview:_emptyConsultsLb];
        }
    }
    
    [self updateTable];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Apagar";
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    [self filterConsultsArrayWithText:text];
    
    [self updateTable];
}

-(void) filterConsultsArrayWithText:(NSString*) text {
    if(text.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.doctorName contains[cd] %@ OR SELF.doctorSpeciality contains[cd] %@ OR SELF.place contains[cd] %@",text, text, text];
        
        NSArray *unfiltredConsults = [_dao listConsults];
        _consults = [unfiltredConsults filteredArrayUsingPredicate:predicate];
        
    } else {
        _consults = [_dao listConsults];
    }
    
    if(_showCompletedConsults == NO)
        [self removeCompletedConsults];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    [self filterConsultsArrayWithText:self.searchBar.text];
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
    [sender endEditing:YES];
}

- (IBAction)showHideCompletedConsults:(id)sender {
    if(_showCompletedConsults == NO) {
        _showCompletedConsults = YES;
        [_showCompletedConsultsBt setTitle:@"Ocultar Concluídos" forState:UIControlStateNormal];
    } else {
        _showCompletedConsults = NO;
        [_showCompletedConsultsBt setTitle:@"Mostrar Concluídos" forState:UIControlStateNormal];
    }
    
    [self filterConsultsArrayWithText:self.searchBar.text];
    [self updateTable];

}

@end
