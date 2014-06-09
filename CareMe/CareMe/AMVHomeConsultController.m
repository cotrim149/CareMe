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

@interface AMVHomeConsultController () {
    AMVConsultDAO *_dao;
    NSArray *_consults;
}

@end

@implementation AMVHomeConsultController

@synthesize tableViewConsults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *consultItem = [[UITabBarItem alloc] initWithTitle:@"Consultas"
                                                                  image:[UIImage imageNamed:@"Calendar-Month.png"]
                                                          selectedImage:[UIImage imageNamed:@"Calendar-Month.png"]];
        self.tabBarItem=consultItem;
        
        _dao = [[AMVConsultDAO alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addComponentsAndConfigureStyle];
}

-(void)viewWillAppear:(BOOL)animated {
    _consults = [_dao listConsults];
    
    [self.tableViewConsults reloadData];
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
    
    self.visualizationSC.tintColor = [AMVCareMeUtil firstColor];
    [self.visualizationSC setTitle:@"Data" forSegmentAtIndex:0];
    [self.visualizationSC setTitle:@"Especialidade" forSegmentAtIndex:1];
    [self.visualizationSC setTitle:@"Local" forSegmentAtIndex:2];
}

-(void) addConsult {
    [self.navigationController pushViewController:[[AMVAddConsultController alloc] init] animated:YES];
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
    
    cell.consulta.text = consult.place;
    cell.dr.text = consult.doctorName;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger linha = indexPath.row;
    
    AMVConsult *consult = [_consults objectAtIndex:linha];
    
    AMVConsultDetailsViewController *consultDetails = [[AMVConsultDetailsViewController alloc]init];
    
    consultDetails.consult = consult;
    
    [self.navigationController pushViewController:consultDetails animated:YES];
    
}

@end
