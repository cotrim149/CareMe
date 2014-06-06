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

@interface AMVHomeConsultController ()

@end

@implementation AMVHomeConsultController
//@synthesize tableViewConsults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *consultItem = [[UITabBarItem alloc] initWithTitle:@"Consultas"
                                                                  image:[UIImage imageNamed:@"Calendar-Month.png"]
                                                          selectedImage:[UIImage imageNamed:@"Calendar-Month.png"]];
        self.tabBarItem=consultItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addComponentsAndConfigureStyle];
    
    //    [self.navigationController pushViewController:a animated:a
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
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Cria a célula desta linha da tabela
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableViewConsults dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        // Faz cache da célula para evitar criar muitos objetos desnecessários durante o scroll
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //Numero da linha
    NSInteger linha = indexPath.row;
    
    //Texto
    cell.textLabel.text = [NSString stringWithFormat:@"Consulta %ld", (long)linha];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Recupera o índice da linha selecionada
    NSInteger linha = indexPath.row;
    
    NSLog(@"%ld",indexPath.row);
    
    //cria mensagem
    NSString *msg = [NSString stringWithFormat:@"Consulta %ld", indexPath.row];
    
    AMVConsultDetailsViewController *consultDetails = [[AMVConsultDetailsViewController alloc]init];
    
    consultDetails.consulta = msg;
    
    [self.navigationController pushViewController:consultDetails animated:YES];
    
}

@end
