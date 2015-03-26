//
//  DayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayCell.h"

#import "Alert.h"
#import "PassthroughScrollView.h"

@interface DayCell () {
  NSMutableArray *_editViews;
  UIPageControl *_pageControl;
  UIView *_staticContainerView;
}

@property (nonatomic, strong) NSMutableArray *attributes;
@property (readonly) UIPageControl *pageControl;
@property (nonatomic, strong) PassthroughScrollView *scrollView;

@end

@implementation DayCell

# pragma mark - Setup

+ (DayCell *)withAttribute:(DayAttribute *)attribute {
  return [self withAttributes:@[attribute]];
}

+ (DayCell *)withAttributes:(NSArray *)attributes {
  NSArray *identifierParts = [attributes valueForKey:@"name"];
  identifierParts = [identifierParts valueForKey:@"capitalizedString"];
  NSString *identifier = [identifierParts componentsJoinedByString:@""];
  identifier = [identifier stringByAppendingString:@"Cell"];
  DayCell *cell = [[DayCell alloc] initWithStyle:0 reuseIdentifier:identifier];
  for (DayAttribute *attribute in attributes) {
    [cell addAttribute:attribute];
  }
  return cell;
}

- (void)addAttribute:(DayAttribute *)attribute {
  if (!self.attributes) {
    self.attributes = [NSMutableArray array];
  }
  [self.attributes addObject:attribute];
}

- (void)build {
  if (!self.scrollView) {
    self.isAccessibilityElement = FALSE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.scrollView = [[PassthroughScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;

    [self.scrollView addSubview:self.staticContainerView];

    if (!self.editViews) {
      [self buildEditViews];
    }

    CGFloat height = self.staticContainerView.frame.size.height;

    NSInteger page = 1;
    for (DayCellEditView *editView in self.editViews) {
      CGRect frame = editView.frame;
      editView.delegate = self;
      if (!editView.superview) {
        height = MAX(height, editView.frame.size.height);
        frame.origin.x = page++ * self.width;
        editView.frame = frame;
        [self.scrollView addSubview:editView];
      }
    }

    for (NSInteger i = 0; i < self.staticViews.count; i++) {
      DayCellStaticView *staticView = self.staticViews[i];
      CGRect frame = staticView.frame;
      frame.size.height = height - SUPERVIEW_SPACING * 2;
      staticView.frame = frame;

      DayCellEditView *editView = self.editViews[i];
      frame = editView.frame;
      frame.size.height = height;
      editView.frame = frame;
    }

    CGRect frame = CGRectMake(0, 0, self.width, height);
    self.scrollView.contentSize = CGSizeMake(page * self.width, height);
    self.scrollView.frame = frame;

    self.staticContainerView.frame = frame;
    
    [self.contentView addSubview:self.scrollView];
    self.frame = self.scrollView.bounds;

    if (self.scrollView.subviews.count > 2) {
      CGRect pageControlFrame = self.pageControl.frame;
      pageControlFrame.origin.y = height - pageControlFrame.size.height;
      self.pageControl.frame = pageControlFrame;
    }
  }
}

- (void)setDay:(Day *)day {
  if (day != _day) {
    _day = day;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (self.scrollView.subviews.count > 2) {
      self.scrollView.delegate = self;
    } else {
      self.scrollView.delegate = nil;
    }
  }

  // Update the interface with the new choice
  if (day) {
    for (NSInteger i = 0; i < self.attributes.count; i++) {
      DayAttribute *attribute = self.attributes[i];
      if (self.staticViews.count > i) {
        DayCellStaticView *staticView = self.staticViews[i];
        DayCellEditView *editView = self.editViews[i];
      
        if (attribute.type == DayAttributeToggle) {
          NSString *choice = [day valueForKey:attribute.name];
          staticView.choice = choice;
          
          NSInteger choiceIndex = [day selectedPropertyForKey:attribute.name];
          editView.choice = choiceIndex;
        } else if (attribute.type == DayAttributeList) {
          NSArray *selected = [day valueForKey:attribute.name];
          staticView.selectedChoices = selected;
          editView.selectedChoices = [selected mutableCopy];
        } else {
          id value = [day valueForKey:attribute.name];
          staticView.value = value;
          editView.value = value;
        }
      }
    }
  }
}

# pragma mark - Edit views

- (DayCellEditView *)buildEditViewForAttribute:(DayAttribute *)attribute {
  CGRect frame = CGRectMake(0, 0, self.width, 0);
  DayCellEditView *editView = [[DayCellEditView alloc] initWithFrame:frame];
  editView.attribute = attribute;
  editView.delegate = self;
  return editView;
}

- (void)buildEditViews {
  _editViews = [NSMutableArray arrayWithCapacity:self.attributes.count];
  
  for (DayAttribute *attribute in self.attributes) {
    DayCellEditView *editView = [self buildEditViewForAttribute:attribute];
    [self.editViews addObject:editView];
  }
}

- (DayCellEditView *)editViewForAttribute:(DayAttribute *)attribute {
  for (DayCellEditView *editView in self.editViews) {
    if (editView.attribute == attribute) {
      return editView;
    }
  }
  return nil;
}

# pragma mark - Static views

- (DayCellStaticView *)buildStaticViewForAttribute:(DayAttribute *)attribute {
  NSInteger index = [self.attributes indexOfObject:attribute];
  NSInteger count = self.attributes.count;
  CGRect frame;
  if (count > 1) {
    CGFloat width = self.width - SUPERVIEW_SPACING * 2;
    CGFloat spacing = (width / self.attributes.count);
    frame = CGRectMake(SUPERVIEW_SPACING + spacing * index, SUPERVIEW_SPACING, spacing - SIBLING_SPACING, 0);
  } else {
    frame = CGRectInset(self.bounds, SUPERVIEW_SPACING, SUPERVIEW_SPACING);
  }
  DayCellStaticView *staticView = [[DayCellStaticView alloc] initWithFrame:frame];
  staticView.attribute = attribute;
  staticView.solitary = count == 1;
  return staticView;
}

- (UIView *)staticContainerView {
  if (!_staticViews) {
    _staticViews = [NSMutableArray array];
  }
  
  if (!_staticContainerView) {
    CGRect frame = CGRectMake(0, 0, self.width, 0);
    CGFloat height = 0;
    _staticContainerView = [[UIView alloc] initWithFrame:frame];
    _staticContainerView.backgroundColor = LIGHT;

    if (!self.staticViews.count) {
      for (DayAttribute *attribute in self.attributes) {
        DayCellStaticView *staticView = [self buildStaticViewForAttribute:attribute];
        height = MAX(height, CGRectGetMaxY(staticView.frame) + SUPERVIEW_SPACING);
        [self.staticViews addObject:staticView];
        [_staticContainerView addSubview:staticView];
      }
    } else {
      for (DayCellStaticView *staticView in self.staticViews) {
        [_staticContainerView addSubview:staticView];
      }
    }

    frame.size.height = height;
    _staticContainerView.frame = frame;
  }
  return _staticContainerView;
}

- (void)setStaticContainerView:(UIView *)staticContainerView {
  _staticContainerView = staticContainerView;
}

- (DayCellStaticView *)staticViewForAttribute:(DayAttribute *)attribute {
  for (DayCellStaticView *staticView in self.staticViews) {
    if (staticView.attribute == attribute) {
      return staticView;
    }
  }

  return nil;
}

# pragma mark - Propagating changes

- (void)attributeToggled:(DayAttribute *)attribute choice:(NSInteger)choice {
  DayCellStaticView *staticView = [self staticViewForAttribute:attribute];

  if (choice == NSNotFound) {
    staticView.choice = nil;
  } else {
    staticView.choice = attribute.choices[choice];
  }

  [self.day selectProperty:attribute.name withindex:choice];
}

- (void)attributeSelectionChanged:(DayAttribute *)attribute selected:(NSArray *)selection {
  DayCellStaticView *staticView = [self staticViewForAttribute:attribute];
  staticView.selectedChoices = selection;

  NSString *key = [attribute.name substringWithRange:NSMakeRange(0, attribute.name.length - 1)];
  key = [key stringByAppendingString:@"Ids"];
  NSArray *selectedIDs = [selection valueForKey:@"id"];

  [self.day updateProperty:key withValue:selectedIDs.copy];
}

- (void)attributeValueChanged:(DayAttribute *)attribute newValue:(id)value {
  DayCellStaticView *staticView = [self staticViewForAttribute:attribute];
  if (!staticView) {
    staticView = self.staticViews.lastObject;
  }
  if (staticView) {
    staticView.value = value;
  }
  [self.day updateProperty:attribute.name withValue:value then:^(id response) {
    if (staticView) {
      staticView.value = value;
    }
  }];
}

# pragma mark - Paging UI

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat left = scrollView.contentOffset.x;
  CGFloat pointOfVisiblePageControl = self.pageControl.frame.origin.x;
  self.pageControl.hidden = left < pointOfVisiblePageControl;
  NSInteger page = round(left / scrollView.frame.size.width);
  self.pageControl.currentPage = page - 1;
}

- (UIPageControl *)pageControl {
  if (!_pageControl) {
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.enabled = NO;
    _pageControl.numberOfPages = self.scrollView.subviews.count - 1;
    [_pageControl sizeToFit];
    CGRect frame = _pageControl.frame;
    frame.origin.x = (self.width - self.pageControl.frame.size.width) / 2;
    _pageControl.frame = frame;
    [self addSubview:_pageControl];
  }
  return _pageControl;
}

@end
