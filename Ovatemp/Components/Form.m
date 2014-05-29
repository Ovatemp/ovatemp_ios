//
//  Form.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Form.h"


#import "NSObject+ClassForProperty.h"

static NSString * const kSectionRows = @"rows";
static NSString * const kSectionTitle = @"title";

@interface Form () {
  UIBarButtonItem *_nextButton;
  UIBarButtonItem *_previousButton;
  NSMutableArray *_sectionOrder;
  NSMutableDictionary *_sections;
  UIToolbar *_toolbar;
}

@end

@implementation Form

# pragma mark - Setup

+ (Form *)withTableView:(UITableView *)tableView {
  Form *form = [self new];
  form.dataSource = tableView.dataSource;
  form.delegate = tableView.delegate;
  tableView.dataSource = form;
  tableView.delegate = form;
  return form;
}

+ (Form *)withViewController:(UIViewController *)viewController {
  if ([viewController valueForKey:@"tableView"]) {
    return [self withTableView:[viewController valueForKey:@"tableView"]];
  } else if ([[viewController valueForKey:@"view"] isKindOfClass:[UITableView class]]) {
    return [self withTableView:[viewController valueForKey:@"view"]];
  }
  return [self new];
}

- (UIToolbar *)toolbar {
  if (!_toolbar) {
    _toolbar = [[UIToolbar alloc] init];
    [_toolbar sizeToFit];

    UIImage *backArrow = [UIImage imageNamed:@"BackArrowSmall.png"];
    _previousButton = [[UIBarButtonItem alloc] initWithImage:backArrow
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(previous:)];

    UIImage *nextArrow = [UIImage imageNamed:@"ForwardArrowSmall.png"];
    _nextButton = [[UIBarButtonItem alloc] initWithImage:nextArrow
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(next:)];

    UIBarButtonItem *flexArea = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done:)];
    _toolbar.items = @[_previousButton, _nextButton, flexArea, doneButton];
  }
  return _toolbar;
}

# pragma mark - Form rows

- (FormRow *)addKeyPath:(NSString *)keyPath toSection:(NSString *)section {
  return [self addKeyPath:keyPath withLabel:nil andImage:nil andType:nil toSection:section];
}

- (FormRow *)addKeyPath:(NSString *)keyPath withLabel:(NSString *)label toSection:(NSString *)section {
  return [self addKeyPath:keyPath withLabel:label andImage:nil andType:nil toSection:section];
}

- (FormRow *)addKeyPath:(NSString *)keyPath
              withLabel:(NSString *)label
               andImage:(NSString *)image
              toSection:(NSString *)section {
  return [self addKeyPath:keyPath withLabel:label andImage:image andType:nil toSection:section];
}

- (FormRow *)addKeyPath:(NSString *)keyPath
         withLabel:(NSString *)label
          andImage:(NSString *)image
           andType:(NSString *)type
         toSection:(NSString *)sectionName {

  if (!_sections) {
    _sections = [NSMutableDictionary new];
    _sectionOrder = [NSMutableArray new];
  }

  if (!label) {
    NSMutableArray *keys = [[keyPath componentsSeparatedByString:@"."] mutableCopy];
    for (int i = 0; i < keys.count; i++) {
      NSString *key = keys[i];
      keys[i] = key.underscore.titleize;
    }
    label = [keys componentsJoinedByString:@" "];
  }

  if (!type) {
    type = [self.representedObject typeNameForKeyPath:keyPath];
  }

  FormRow *row = [FormRow rowWithKeyPath:keyPath label:label imageName:image type:type];
  [self addRow:row toSection:sectionName];

  return row;
}

# pragma mark - Information rows

- (FormRow *)addLabel:(NSString *)label toSection:(NSString *)sectionName whenTapped:(FormRowTapped)onSelect {
  return [self addLabel:label
              withImage:nil
              toSection:sectionName
             whenTapped:onSelect];
}

- (FormRow *)addLabel:(NSString *)label
            withImage:(NSString *)image
            toSection:(NSString *)sectionName
           whenTapped:(FormRowTapped)onSelect {
  return [self addLabel:label
              withImage:image
       andAccessoryType:UITableViewCellAccessoryDisclosureIndicator
              toSection:sectionName
             whenTapped:onSelect];
}

- (FormRow *)addLabel:(NSString *)label
            withImage:(NSString *)image
     andAccessoryType:(UITableViewCellAccessoryType)accessoryType
            toSection:(NSString *)sectionName
           whenTapped:(FormRowTapped)onSelect {
  FormRow *row = [FormRow new];
  row.accessoryType = accessoryType;
  row.label = label;
  row.imageName = image;
  row.onSelect = onSelect;

  [self addRow:row toSection:sectionName];

  return row;
}

# pragma mark - Overridden data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  int sections = 0;// [self.nextDataSource numberOfSectionsInTableView:tableView];
  if (_sections) {
    sections += _sections.count;
  }
  return sections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FormRow *row = [self rowAtIndexPath:indexPath];
  return [row buildCellForObject:self.representedObject inTableView:tableView atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  FormRow *row = [self rowAtIndexPath:indexPath];

  [row becomeFirstResponder];

  if (row.onSelect) {
    row.onSelect(row);
  }

  if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  } else {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
  int sectionRows = 0;// [self.nextDataSource tableView:tableView numberOfRowsInSection:sectionIndex];
  NSDictionary *section = [self sectionAtIndex:sectionIndex];
  if (section) {
    NSArray *rows = section[kSectionRows];
    sectionRows += rows.count;
  }
  return sectionRows;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
    return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
  } else {
    return YES;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
  NSString *title = [self.dataSource tableView:tableView titleForHeaderInSection:sectionIndex];
  if (!title && _sections.count > 1) {
    NSDictionary *section = [self sectionAtIndex:sectionIndex];
    if (section) {
      title = section[kSectionTitle];
    }
  }
  return title;
}

# pragma mark - Row and section helpers

- (void)addRow:(FormRow *)row toSection:(NSString *)sectionName {
  NSMutableDictionary *section = [self sectionWithName:sectionName];
  row.form = self;
  row.section = [_sectionOrder indexOfObject:section];
  row.index = [section[kSectionRows] count];
  [section[kSectionRows] addObject:row];
}

- (FormRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableDictionary *section = [self sectionAtIndexPath:indexPath];
  if (indexPath.row < [section[kSectionRows] count]) {
    return section[kSectionRows][indexPath.row];
  }
  return nil;
}

- (NSMutableDictionary *)sectionAtIndex:(NSInteger)index {
  if (index < _sectionOrder.count) {
    return _sectionOrder[index];
  }
  return nil;
}

- (NSMutableDictionary *)sectionAtIndexPath:(NSIndexPath *)indexPath {
  return [self sectionAtIndex:indexPath.section];
}

- (NSMutableDictionary *)sectionWithName:(NSString *)name {
  NSMutableDictionary *section = _sections[name];
  if (!section) {
    section = [NSMutableDictionary new];
    section[kSectionTitle] = name;
    section[kSectionRows] = [NSMutableArray array];
    _sections[name] = section;
    [_sectionOrder addObject:section];
  }
  return _sections[name];
}

# pragma mark - Interface navigation

- (void)done:(id)sender {
  [self.currentRow resignFirstResponder];
  self.currentRow = nil;
}

- (void)next:(id)sender {
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentRow.index + 1 inSection:self.currentRow.section];
  FormRow *row = [self rowAtIndexPath:indexPath];
  if (!row) {
    indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentRow.section + 1];
    row = [self rowAtIndexPath:indexPath];
  }
  [row becomeFirstResponder];
}

- (void)previous:(id)sender {
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentRow.index - 1 inSection:self.currentRow.section];
  FormRow *row = [self rowAtIndexPath:indexPath];
  if (!row) {
    NSInteger sectionIndex = self.currentRow.section - 1;
    NSDictionary *section = [self sectionAtIndex:sectionIndex];
    if (section) {
      NSInteger lastRowIndex = [section[kSectionRows] count] - 1;
      indexPath = [NSIndexPath indexPathForRow:lastRowIndex inSection:sectionIndex];
      row = [self rowAtIndexPath:indexPath];
    }
  }
  [row becomeFirstResponder];
}

# pragma mark - Message forwarding

- (id)forwardingTargetForSelector:(SEL)aSelector {
  if ([self.dataSource respondsToSelector:aSelector]) {
    return self.dataSource;
  } else if ([self.delegate respondsToSelector:aSelector]) {
    return self.delegate;
  }
  return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  BOOL responds = [super respondsToSelector:aSelector] ||
    [self.dataSource respondsToSelector:aSelector] ||
    [self.delegate respondsToSelector:aSelector];
  return responds;
}

@end
