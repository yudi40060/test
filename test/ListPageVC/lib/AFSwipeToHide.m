// Copyright (c) 2014 appFigures Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFSwipeToHide.h"

@interface AFSwipeToHide()<UITableViewDelegate>
{
    CGFloat _dragStartPosition;
    BOOL _isDragging;
    CGFloat currentPosition;
}
@end

@implementation AFSwipeToHide

- (instancetype)init {
    self = [super init];
    if (self) {
        _scrollDistance = 20.0;
    }
    return self;
}

- (void)beginDragAtPosition:(CGFloat)position {
    _dragStartPosition = MAX(position, 0.0);
    _isDragging = YES;
}

- (void)scrollToPosition:(CGFloat)position andScrollView:(UIScrollView *)scrollView {
    
    if (position <= 0.0 || (position >= scrollView.contentSize.height - HEIGHT(scrollView))) {
        
        [self _setPercentHidden:0.0 interactive:NO andScrollView:scrollView];
    }
    else if (_isDragging)
    {
        
        CGFloat diff = position - _dragStartPosition;
        if (scrollView.contentSize.height-scrollView.bounds.size.height-scrollView.contentOffset.y>0) {
             [self _setPercentHidden:(diff / _scrollDistance) interactive:YES andScrollView:scrollView];
        }
       
        if (diff < 0.0 || position < currentPosition) {
            _dragStartPosition = position;
        }
        currentPosition = position;
    }
}

- (void)endDragAtTargetPosition:(CGFloat)position velocity:(CGFloat)velocity andScrollView:(UIScrollView *)scrollView{
    _isDragging = NO;
    
    BOOL shouldHide = YES;
    
    if (velocity < 0.0 ||
        (velocity == 0.0 && _percentHidden == 0.0) ||
        (position < _scrollDistance))
    {
        shouldHide = NO;
    }
    
    if ((position >= scrollView.contentSize.height - HEIGHT(scrollView))) {
        return;
    }
    [self _setPercentHidden:shouldHide ? 1.0 : 0.0 interactive:NO andScrollView:scrollView];
}

- (void)_setPercentHidden:(CGFloat)percent interactive:(BOOL)interactive andScrollView:(UIScrollView *)scrollView {
    if (percent < 0.0) percent = 0.0;
    if (percent > 1.0) percent = 1.0;
    
    if (percent == _percentHidden) return;
    
    _percentHidden = percent;
    
    [self.delegate swipeToHide:self didUpdatePercentHiddenInteractively:interactive andScrollView:scrollView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate swipeToHide:tableView didSelectRowAtIndexPath:indexPath];
}
@end

@implementation AFSwipeToHide(Delegate)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self beginDragAtPosition:scrollView.contentOffset.y + scrollView.contentInset.top];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self endDragAtTargetPosition:targetContentOffset->y + scrollView.contentInset.top velocity:velocity.y andScrollView:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollToPosition:scrollView.contentOffset.y + scrollView.contentInset.top andScrollView:scrollView];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
