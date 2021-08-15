#!/bin/python3
import sys
import json
import shutil
import os
import subprocess
import random
import time
import pandas as pd
import argparse
import copy


from os import listdir
from os.path import isfile, join, basename ,splitext
from os import walk

from pandas.core.frame import DataFrame


def listToStringwithDoubleQuotes(mylist):
    copy = mylist.copy()
    return '["'+ '","'.join(copy)+'"]'

def getNumberPatternTrials(base_path= 'assets/images/pattern_numbers/',n_choices =4):
    '''
    '''
    #distances = [2,3,4]
    distances = [1]
    missing_index = [0,2,4]
    direction = [1,-1]
    problem_len = 5
    choices_len= 4
    min_num = 1
    max_num = 30

    def appendBasePath(my_list):
        new_list = []
        for i in range(0,len(my_list)):
            item = base_path + str(my_list[i]) + ".PNG"
            new_list.append(item)
        return new_list

    
    trials = []
    for dist in distances:
        for missing in missing_index:
            for dir in direction:
                if(dir == 1):
                    first_number = random.randint(min_num,max_num - (problem_len-1)*dist)
                else:
                    first_number = random.randint(min_num + (problem_len-1)*dist,max_num)
                numbers = [first_number + i*dist*dir for i in range(problem_len)]
                translation = "\"dist:"+str(dist)+",missing:"+str(missing)+",dir:"+str(dir) +"\""

                choices = []
                choices.append(numbers[missing])
                max_offset = dist*2
                while(len(choices) < choices_len):
                    correct_solution = choices[0]
                    guess = correct_solution+random.randint(-max_offset, max_offset)
                    if(guess > max_num or guess < min_num):
                        continue
                    if(guess in choices):
                        continue
                    choices.append(guess)

                
                random.shuffle(choices)

                numbers = appendBasePath(numbers)
                choices = appendBasePath(choices)

                solution = numbers.copy()
                solution_str = listToStringwithDoubleQuotes(solution)
                problem = numbers.copy()
                problem[missing] = ""
                problem_str = listToStringwithDoubleQuotes(problem)
                choices_str = listToStringwithDoubleQuotes(choices)

                trials.append([problem_str,solution_str,choices_str,translation])

    return trials
        



def getPatternUnitOfRepeatTrials(symbols = [
 'assets/images/pattern_symbols/triangle.PNG',
 'assets/images/pattern_symbols/tripleCircle.PNG',
 'assets/images/pattern_symbols/ArrowOverlay.PNG',
 'assets/images/pattern_symbols/ArrowLeft.PNG',
 'assets/images/pattern_symbols/square.PNG',
 'assets/images/pattern_symbols/robotface.PNG',
 'assets/images/pattern_symbols/circle.PNG',
 'assets/images/pattern_symbols/rhombus.PNG',
 'assets/images/pattern_symbols/ArrowRight.PNG']
,choose_from=None,n_choices =3):
    '''
    '''

    complete_patterns = [
        ([0,1,1,0,1,1],[[0,1,1],[0,1,1,0],[0,1]]), #1 ABBABB
        ([0,0,1,0,0,1],[[0,0,1],[0,0],[0,1]]), #1 AABAAB <- as in Rittle-Johnson et.al (2015)
        #[0,1,0,2,0,1], #2 ABACAB
       # [0,1,2,2,1,0] , #3 ABCCBA <- does not have one
       # [0,1,0,1,1,0,1,1,1] , #4 ABABBABBB <- growing pattern does not have a single unit of repeat.
        ([0,1,2,3,4,0],[[0,1,2,3,4],[0,1,2,3,4,0],[0,1,2]]) , #5 AJDXNA  
       # [0,1,0,2,0,3,0,1,0,2,0,3] , #6 ABACADABACAD
       # [0,1,2,3,2,1,0] , #7 ABCDCDA
       # [0,1,1,1,0,1,1,0,1] , #8 ABBBABBAB
        ]
    
    pattern_trans_table= ["A","B","C","D","E","F","G","H"]
    trials = []

    for pattern_tuple in complete_patterns:
        
        pattern = pattern_tuple[0]

        choice_patterns = pattern_tuple[1]

        shuffled_sym = list(symbols)
        random.shuffle(shuffled_sym)
        problem = []
        translation = []
        for index in pattern:
            problem.append(shuffled_sym[index])
            translation.append(pattern_trans_table[index])


        choose_from = []
        for choice in choice_patterns:
            choose_from.append([])
            for index in choice:
                choose_from[-1].append(shuffled_sym[index])


        solution = choose_from[0].copy()


        # problem[missing] = ""

        # we also shuffle this so the correct choice is not always leftmost.
        random.shuffle(choose_from)

        problem = listToStringwithDoubleQuotes(problem)
        solution= listToStringwithDoubleQuotes(solution)
        choose_from_strings = []
        for my_list in choose_from:
            string_list = listToStringwithDoubleQuotes(my_list)
            print("-"*80)
            print(string_list)
            print("-"*80)
            choose_from_strings.append(string_list)

        choice = listToStringwithDoubleQuotes(choose_from_strings)
        choice = choice.replace("\"[\"","[\"")
        choice = choice.replace("\"]\"","\"]")
        translation = '"' + "".join(translation) + '"'

        trials.append([problem,solution,choice,translation])

    return trials
 

def getPatternGeneralizeTrials(symbols = [
 'assets/images/pattern_symbols/triangle.PNG',
 'assets/images/pattern_symbols/tripleCircle.PNG',
 'assets/images/pattern_symbols/ArrowOverlay.PNG',
 'assets/images/pattern_symbols/ArrowLeft.PNG',
 'assets/images/pattern_symbols/square.PNG',
 'assets/images/pattern_symbols/robotface.PNG',
 'assets/images/pattern_symbols/circle.PNG',
 'assets/images/pattern_symbols/rhombus.PNG',
 'assets/images/pattern_symbols/ArrowRight.PNG']
,choose_from=None,n_choices =4):
    '''
    '''

    complete_patterns = [
        [0,1,1,0,1,1] , #1 ABBABB
        [0,1,0,2,0,1], #2 ABACAB
        [0,1,2,2,1,0] , #3 ABCCBA
        [0,1,0,1,1,0,1,1,1] , #4 ABABBABBB
      #  [0,1,2,3,4,0] , #5 AJDXNA  Not possible with only 4 choices..
       # [0,1,0,2,0,3,0,1,0,2,0,3] , #6 ABACADABACAD
       # [0,1,2,3,2,1,0] , #7 ABCDCDA
       # [0,1,1,1,0,1,1,0,1] , #8 ABBBABBAB
        ]
    
    pattern_trans_table= ["A","B","C","D","E","F","G","H"]
    missing_pos = [0,-1]
    trials = []

    for pattern in complete_patterns:
        for missing in missing_pos:
            shuffled_sym = list(symbols)
            random.shuffle(shuffled_sym)
            solution = []
            translation = []
            for index in pattern:
                solution.append(shuffled_sym[index])
                translation.append(pattern_trans_table[index])

            problem = solution.copy()
            # problem[missing] = ""

            # get the choices.
            # for the generalization we want anything that does not occur in the 
            # original pattern
            choose_from = []
            while(len(choose_from) < n_choices):
                next_symbol = random.choice(symbols)
                if(next_symbol in problem):
                    continue
                if(next_symbol in choose_from):
                    continue
                choose_from.append(next_symbol)

            # we also shuffle this so the correct choice is not always leftmost.
            random.shuffle(choose_from)

            user_input = ["" for i in range(len(problem))]
            problem = listToStringwithDoubleQuotes(problem)
            user_input = listToStringwithDoubleQuotes(user_input)
            solution= listToStringwithDoubleQuotes(solution)
            choice = listToStringwithDoubleQuotes(choose_from)
            translation = '"' + "".join(translation) + '"'
            trials.append([problem,solution,choice,translation,user_input])

    return trials
 

def getPatternExtendTrials(symbols = [
 'assets/images/pattern_symbols/triangle.PNG',
 'assets/images/pattern_symbols/tripleCircle.PNG',
 'assets/images/pattern_symbols/ArrowOverlay.PNG',
 'assets/images/pattern_symbols/ArrowLeft.PNG',
 'assets/images/pattern_symbols/square.PNG',
 'assets/images/pattern_symbols/robotface.PNG',
 'assets/images/pattern_symbols/circle.PNG',
 'assets/images/pattern_symbols/rhombus.PNG',
 'assets/images/pattern_symbols/ArrowRight.PNG']
,choose_from=None,n_choices =4):
    '''
    '''

    complete_patterns = [
        [0,1,1,0,1,1] , #1 ABBABB
        [0,1,0,2,0,1], #2 ABACAB
        [0,1,2,2,1,0] , #3 ABCCBA
        [0,1,0,1,1,0,1,1,1] , #4 ABABBABBB
        [0,1,2,3,4,0] , #5 AJDXNA 
       # [0,1,0,2,0,3,0,1,0,2,0,3] , #6 ABACADABACAD
       # [0,1,2,3,2,1,0] , #7 ABCDCDA
       # [0,1,1,1,0,1,1,0,1] , #8 ABBBABBAB
        ]
    
    pattern_trans_table= ["A","B","C","D","E","F","G","H"]
    missing_pos = [0,-1]
    trials = []

    for pattern in complete_patterns:
        for missing in missing_pos:
            shuffled_sym = list(symbols)
            random.shuffle(shuffled_sym)
            solution = []
            translation = []
            for index in pattern:
                solution.append(shuffled_sym[index])
                translation.append(pattern_trans_table[index])

            problem = solution.copy()
            problem[missing] = ""

            # get the choices.
            choose_from = []
            # we need to have the correct one for sure.
            choose_from.append(solution[missing])
            # now we use some others from the pattern.
            unique_symbols = set(solution)
            unique_symbols.remove(solution[missing])

            while(len(choose_from) < n_choices and len(unique_symbols) > 0):
                choose_from.append(unique_symbols.pop())
            # if we still do not have enough choices we select them from the remaining symbols.
            while(len(choose_from) < n_choices):
                next_symbol = random.choice(symbols)
                if(next_symbol in choose_from):
                    continue
                choose_from.append(next_symbol)

            # we also shuffle this so the correct choice is not always leftmost.
            random.shuffle(choose_from)

            problem = listToStringwithDoubleQuotes(problem)
            solution= listToStringwithDoubleQuotes(solution)
            choice = listToStringwithDoubleQuotes(choose_from)
            translation = '"' + "".join(translation) + '"'
            trials.append([problem,solution,choice,translation])

    return trials
        

def nonSymbTrialsFromFile():
    """
    here we use pre generated trials from a file. However to have less trials we randomly choose some subset of those trials.
    """
    filename = "python_templates/dot_gen_trials.csv"
    df = pd.read_csv(filename, sep=",")

    lst = df.to_dict('records')
    lst_left = lst[:len(lst)//2]
    lst_buckets = [[],[],[],[]]

    for row in (lst_left):
        lst_buckets[row["bucket"]-1].append(row)

    for i in range(0,len(lst_buckets)):
        bucket = lst_buckets[i]
        lst_buckets[i]= random.sample(bucket,5)

    print("-"*80)
    print("buckets len:",len(lst_buckets[0]))
    print("-"*80)

    lst_left = lst_buckets[0]
    for i in range(1,len(lst_buckets)):
        lst_left.extend(lst_buckets[i])

    lst_right = copy.deepcopy(lst_left)
    for row_index in range(0,len(lst_left)):
        tmp = lst_left[row_index]["left_num"]
        lst_left[row_index]["left_num"] = lst_left[row_index]["right_num"]
        lst_left[row_index]["right_num"] =tmp 
        lst_left[row_index]["direction"] ="Left"
 

    lst_left.extend(lst_right)
    nonSymbTrialsStats(lst_left)
    return lst_left



def nonSymbTrialGen(numbers=[i for i in range(5,22)], buckets = [{'min':1,'max':1.3},{'min':1.3,'max':1.9},{'min':1.9,'max':3},{'min':3,'max':4}]):
    '''
    returns a dict with the fields that are needed. it does not however tell you the filename!
    '''

    all_matchings = []

    print("starting..")
    
    for left_num in range(22,5,-1):
        for right_num in range(5,22):
            # no same things.
            if(left_num <= right_num):
                print("left:",left_num,"right",right_num, "BREAK")
                break
                continue
            higher_num = max(left_num,right_num)
            lower_num = min(left_num,right_num)
            this_match = {"left_num":left_num,"right_num":right_num,"solution":higher_num,"ratio":round(higher_num/lower_num,2),"solution":"RIGHT"}
            
            this_match['bucket'] = -1
            for bucket_index in range(0,len(buckets)):
                bucket = buckets[bucket_index]
                if this_match['ratio'] <= bucket['max'] and this_match['ratio'] >= bucket['min']:
                    this_match['bucket'] = bucket_index
                    break
            # if it does not fit into a bucket we dont need it.
            """
            if(this_match['bucket'] == -1):
                continue
            """

            all_matchings.append(this_match)

    # until here left is always larger.
    all_matchings = random.sample(all_matchings,20)
    matchings_left = copy.deepcopy(all_matchings)
    for row_index in range(0,len(matchings_left)):
        tmp = matchings_left[row_index]["left_num"]
        matchings_left[row_index]["left_num"] = matchings_left[row_index]["right_num"]
        matchings_left[row_index]["right_num"] =tmp 
        matchings_left[row_index]["solution"] ="LEFT"
    all_matchings.extend(matchings_left) 
    # debug:
    df = DataFrame.from_records(all_matchings)
    df.to_csv("generated_trials.csv")
    return all_matchings

def nonSymbTrialsStats(data):
    buckets_n = [0,0,0,0]
    directions = [0,0]
    for match_index in range(0,len(data)):
        match = data[match_index]
        #print("left:",match["left_num"],"right:",match["right_num"])
        buckets_n[match["bucket"] -1] += 1

    print(":-:"*20)
    print("total len:",len(data))
    print("buckets freq:",buckets_n)
    print(":-:"*20)
    
    return


def genNonSymbTrials():
    '''
    this function knows  how to name the files and what to do with the trials generated by nonsymTrialGen
    '''
    #all_matchings = nonSymbTrialGen()
    all_matchings = nonSymbTrialsFromFile()
    nonSymbTrialsStats(all_matchings)
    ids_area_control = [i for i in range(0,17)]
    ids_radius_control = [i for i in range(17,34)]
    # we have each match 2 times. once for the area controlled and another time for the radius.
    min_n_dots = 5
    trials = []
    for match_index in range(0,len(all_matchings)):
        match = all_matchings[match_index]
        left_num = match['left_num']
        right_num = match['right_num']
        solution_num = match['solution']

        left_filename_area = "id_"+str(ids_area_control[left_num-min_n_dots])+"_dots_"+str(left_num)+".png"
        right_filename_area = "id_"+str(ids_area_control[right_num-min_n_dots])+"_dots_"+str(right_num)+".png"
        solution_filename_area = "id_"+str(ids_area_control[solution_num-min_n_dots])+"_dots_"+str(solution_num)+".png"
        trials.append([left_filename_area,right_filename_area,solution_filename_area,json.dumps(match)])

        '''
        left_filename_radius = "id_"+str(ids_radius_control[left_num-min_n_dots])+"_dots_"+str(left_num)+".png"
        right_filename_radius = "id_"+str(ids_radius_control[right_num-min_n_dots])+"_dots_"+str(right_num)+".png"
        solution_filename_radius = "id_"+str(ids_radius_control[solution_num-min_n_dots])+"_dots_"+str(solution_num)+".png"
        trials.append([left_filename_radius,right_filename_radius,solution_filename_radius,match])
        '''



    return trials




def genSymbolicNumberCompareTrials(distances=[1,2,3,4,5,6,7,8],numbers=[1,2,3,4,5,6,7,8,9]):
    '''
    our output tells us that we have:
    have  8 for distance: 1
    have  7 for distance: 2
    have  4 for distance: 5
    have  3 for distance: 6
    so we use the distance 5 and 6 double to make it more balanced
    '''
    trials_per_dist = []
    for dist in distances:
        dist_poss_count = 0
        cur_dist = []
        for num in numbers:
            left_num = num
            right_num = num+dist
            solution = max(left_num,right_num)
            if (not left_num in numbers) or (not right_num in numbers):
                continue
            # append both directions
            trials = []
            trials.append([left_num,right_num,solution,dist])
            trials.append([right_num,left_num,solution,dist])
            dist_poss_count +=1
            cur_dist.append(trials)

        trials_per_dist.append(cur_dist)
        print("have ",dist_poss_count,"for distance:",dist)

    for i in range(0,len(trials_per_dist)):
        n_per_dist = 4 
        # the trials are longer than n_per_dist so we randomly select some trials.
        if(len(trials_per_dist[i])>= n_per_dist):
            trials_per_dist[i] = random.sample(trials_per_dist[i],n_per_dist)
            continue

        # the trials are shorter than n_per_dist so we use the trials multiple times. 
        cur_dist = copy.deepcopy(trials_per_dist[i])
        while(len(cur_dist)+len(trials_per_dist[i]) <= n_per_dist):
            cur_dist.extend(trials_per_dist[i])
        if(len(cur_dist) < n_per_dist):
            diff =  n_per_dist - len(cur_dist)
            cur_dist.extend(random.sample(trials_per_dist[i],diff))
        trials_per_dist[i] = cur_dist



    trials = []
    for dist in trials_per_dist:
        for d in dist:
            for trial in d:
                trials.append(trial)



    return trials

def appendPathToNum(num,base_path= "assets/images/pattern_numbers/",file_end=".PNG"):
    return base_path + str(num)+file_end




def getNewNumericalCompTrials():
    trials = []
    base_path = "assets/images/pattern_numbers/"
    file_end = ".PNG"
    for trial in genSymbolicNumberCompareTrials():
        trials.append([base_path+str(trial[0])+file_end,base_path+str(trial[1])+file_end,base_path+str(trial[2])+file_end,"\"left:"+str(trial[0])+",right"+str(trial[1])+",dist"+str(trial[3])+"\""])

    return trials


def genNewOrdinalNumberVerificationTrials(filename="python_templates/ord_trials.csv"):
    df = pd.read_csv(filename, sep=",")
    trial_dict = df.to_dict('records')
    trials = []
    for row in trial_dict:
        trials.append([appendPathToNum(row['left']),appendPathToNum(row['middle']),appendPathToNum(row['right']),row['solution'],row])
    
    return trials
    

def genOrdinalNumberVerificationTrials(distances=[1,2,3],numbers=[1,2,3,4,5,6,7,8,9]):
    '''
    our output tells us that we have:
    have  7 for distance: 1
    have  5 for distance: 2
    have  3 for distance: 3
    so we use the distance 3 ones double to make it more balanced
    '''

    dist_lsts = []
    for dist in distances:
        dist_poss_count = 0
        lst_per_dist = []
        for num in numbers:
            left_num = num
            mid_num = num+dist
            right_num = num+2*dist
            solution = "IN_ORDER"
            if (not left_num in numbers) or (not mid_num in numbers) or (not right_num in numbers):
                continue

            trials = []
            # append both directions
            trials.append([appendPathToNum(left_num),appendPathToNum(mid_num),appendPathToNum(right_num),solution,"ASCENDING",dist])
            trials.append([appendPathToNum(right_num),appendPathToNum(mid_num),appendPathToNum(left_num),solution,"DESCENDING",dist])

            solution = "MIXED_ORDER"
            # ascending mixed

            trials.append([appendPathToNum(mid_num),appendPathToNum(right_num),appendPathToNum(left_num),solution,"ASCENDING",dist])
            #descending mixed
            trials.append([appendPathToNum(mid_num),appendPathToNum(left_num),appendPathToNum(right_num),solution,"DESCENDING",dist])

            lst_per_dist.append(trials)
            dist_poss_count +=1

        print("have ",dist_poss_count,"for distance:",dist)
        dist_lsts.append(lst_per_dist)
        
    for i in range(0,len(dist_lsts)):
        n_per_dist = 4
        if(len(dist_lsts[i])>= n_per_dist):
            dist_lsts[i] = random.sample(dist_lsts[i],n_per_dist)
            continue
        trials_for_dist = copy.deepcopy(dist_lsts[i])
        while(len(trials_for_dist)+len(dist_lsts[i]) <= n_per_dist):
            trials_for_dist.extend(dist_lsts[i])
        if(len(trials_for_dist) < n_per_dist):
            diff =  n_per_dist - len(trials_for_dist)
            trials_for_dist.extend(random.sample(dist_lsts[i],diff))
        dist_lsts[i] = trials_for_dist


    trials = []
    for dist in dist_lsts:
        for d in dist:
            for trial in d:
                trials.append(trial)

    print("-"*80)
    print(trials)
    print("-"*80)
    return trials

def genNumLineTrials(ranges=[x for x in range(32,64+1)],targets=[x for x in range(4,32+1)]):
    '''
    our output tells us that we have:
    so we use the distance 3 ones double to make it more balanced
    '''
    trials = []

    for rang in ranges:
        for num in targets:
            trials.append([rang,num])
    trials = random.sample(trials,24)

    return trials


def getPossibleMatchings(numbers_left=[2,3,4,5,6,7,8,9],numbers_right=[2,3,4,5,6,7,8,9]):
    matchings = []
    for num_1 in numbers_left:
        for num_2 in numbers_right:
            matchings.append([num_1,num_2])
    return matchings


def getTripleAdditionTrials(numbers=[i for i in range(10,100)]):
    calcs = []
    for num_1 in numbers:
        for num_2 in numbers:
            for num_3 in numbers:
                solution = num_1+num_2+num_3
                calcs.append([num_1,num_2,num_3,solution])
    n_two_digits = 60
    calcs = random.sample(calcs,n_two_digits)
    template_friendly_trials = []
    for calc in calcs:
        template_friendly_trials.append([str(calc[0])+"+"+str(calc[1]),calc[2],calc[3]])
    return template_friendly_trials
    

 


def genAdditionTrials(numbers=[2,3,4,5,6,7,8,9]):
    '''
    '''
    trials = []

    # single digit numbers
    matchings = getPossibleMatchings(numbers_left=numbers,numbers_right=numbers)
    for match in matchings:
        solution = match[0]+match[1]
        trials.append([match[0],match[1],solution])
    

    two_digit_trials = []
    matchings = getPossibleMatchings(numbers_left=[i for i in range(10,100)],numbers_right=[i for i in range(10,100)])
    for match in matchings:
        solution = match[0]+match[1]
        two_digit_trials.append([match[0],match[1],solution])

    # solution must be 2 digits also 
    two_digit_trials = [i for i in two_digit_trials if not i[2] >= 100]

    # only with "zehnerübergang"
    two_digit_trials = [i for i in two_digit_trials if ((i[0]%10) + (i[1]%10))>10]

    # ignore stuff with the same last digit (66+36,...)
    two_digit_trials = [i for i in two_digit_trials if not (i[0]%10) == (i[1]%10)]

    # ignore numbers with same digits (55,66,...) 
    two_digit_trials = [i for i in two_digit_trials if not (((i[0]%10) == ((i[0]//10)%10)) or ((i[1]%10) == ((i[1]//10)%10)) or ((i[2]%10) == ((i[2]//10)%10)))]

    print("len two digits.",len(two_digit_trials))
    n_two_digits = 60
    two_digit_trials = random.sample(two_digit_trials,n_two_digits)

    

    # no same operants
    trials = [i for i in trials if not i[0] == i[1]]

# ignore 2 digit operants for kids.
#    trials = trials + two_digit_trials
    return trials

def genMultiplicationTrials(numbers = [2,3,4,5,6,7,8,9]):
    trials = []
    for num_1 in numbers:
        for num_2 in numbers:
            if(num_1 == num_2):
                continue
            solution = num_1*num_2
            trials.append([num_1,num_2,solution])

    two_digit_trials = getPossibleMatchings(numbers_left=[i for i in range(12,100)],numbers_right=[i for i in range(3,10)])
    for numbers in two_digit_trials:
        # add the mult result.
        numbers.append(numbers[0]*numbers[1])


    #two_digit_trials = [i for i in two_digit_trials if not (i[0] == i[1])]
    two_digit_trials = [i for i in two_digit_trials if (i[2] < 100)]
    #two_digit_trials = [i for i in two_digit_trials if not (((i[0]%10) == ((i[0]//10)%10)) or ((i[1]%10) == ((i[1]//10)%10)) or ((i[2]%10) == ((i[2]//10)%10)))]

    print("len two digits.",len(two_digit_trials))

    #n_two_digits = 60
    #two_digit_trials = random.sample(two_digit_trials,n_two_digits)

    

    return trials + two_digit_trials


def genSubtractionTrials(numbers= [2,3,4,5,6,7,8,9]):
    trials = genAdditionTrials(numbers)
    for trial in trials:
        # swap the solution with the first operant
        print(trial)
        temp = trial[0]
        trial[0] = trial[2]
        trial[2] = temp

    return trials

def genTypingTrials(numbers=[x for x in range(1,300)]):
    '''
    we want to resemble the arithmetic trials as this task will be the control for that.
    there we have solutions with the following digits:
    single 152 double 245 triple 55
    so we will do the same here.
    '''

    trials = []

    numbers = [i for i in range(1,20)]
    for num in numbers:
        trials.append([num,num])
    return trials


    n_singles = 152
    n_doubles = 245
    n_triple = 55

    single_digit_numbers = [i for i in range(0,10)]
    double_digit_numbers = [i for i in range(10,100)]
    # we choose the range of 300 as this is also the case with the arithmetic trials
    triple_digit_numbers = [i for i in range(100,300)]

    for single in range(0,n_singles):
        solution = random.choice(single_digit_numbers)
        trials.append([solution,solution])

    for double in range(0,n_doubles):
        solution = random.choice(double_digit_numbers)
        trials.append([solution,solution])

    for triple in range(0,n_triple):
        solution = random.choice(triple_digit_numbers)
        trials.append([solution,solution])

    return trials








def insertListIntoTemplate(template_string,numbers_list):
    '''
    insertLIstIntoTemplate
    inserts a list into a template
    the template string needs to have the spots marked with INSERT_HERE_0,INSERT_HERE_1,...
    @ret the string with everything replaced.
    '''
    for index in range(0,len(numbers_list)):
        template_string = template_string.replace("INSERT_HERE_"+str(index),str(numbers_list[index]))
    return template_string






def genMathAnxietyTrials():
        return [[i] for i in range(1,14)]


def main():


    generatorMap = {"symb":getNewNumericalCompTrials,
    "ord":genOrdinalNumberVerificationTrials,#genNewOrdinalNumberVerificationTrials,
    "numline":genNumLineTrials,
    "add":genAdditionTrials,
    "triple_add":getTripleAdditionTrials,
    "sub":genSubtractionTrials,
    "mult":genMultiplicationTrials,
    "speed":genTypingTrials,
    "nonsymb":genNonSymbTrials,
    "mathanxiety":genMathAnxietyTrials,
    "pattern_extend":getPatternExtendTrials,
    "pattern_generalize":getPatternGeneralizeTrials,
    "pattern_uof":getPatternUnitOfRepeatTrials,
    "pattern_num":getNumberPatternTrials,
    }


    parser = argparse.ArgumentParser(description="Trial generator for DNA Tasks.")
    parser.add_argument('task',choices=generatorMap.keys(),
    help="this arg lets you choose the task you want to generate the trials for.")

    parser.add_argument('template', help="path to template file.")
    # in order to get replicable results we use a random seed
    #random.seed(42)
    args = parser.parse_args()

    trials = generatorMap[args.task]()

    df = DataFrame.from_records(trials)
    df.to_csv("generated_trials/"+args.task+".csv",sep=";")

    template_file = args.template
    temp_string = ""
    with open(template_file) as tempfile:
        temp_string = tempfile.read()

    string_with_all_trials = ""
    for trial in trials:
        string_with_all_trials += insertListIntoTemplate(temp_string,trial)
    
    print(string_with_all_trials)

    






        

if __name__ == "__main__":
    main()
    
