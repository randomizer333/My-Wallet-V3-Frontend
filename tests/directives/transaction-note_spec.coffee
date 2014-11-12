describe "Transaction Note Directive", ->
  $compile = undefined
  $rootScope = undefined
  element = undefined
  isoScope = undefined
  
  # Load the myApp module, which contains the directive
  beforeEach module("walletApp")
  beforeEach(module('templates/transaction-note.html'))
  
  # Store references to $rootScope and $compile
  # so they are available to all tests in this describe block
  beforeEach inject((_$compile_, _$rootScope_) ->
    
    # The injector unwraps the underscores (_) from around the parameter names when matching
    $compile = _$compile_
    $rootScope = _$rootScope_
    
    $rootScope.transaction = {note: "Hello World"}
    
    return
  )
  
  beforeEach ->
    element = $compile("<transaction-note transaction='transaction'></transaction-note>")($rootScope)
    $rootScope.$digest()
    isoScope = element.isolateScope()
  
  it "should show the note", ->
    expect(element.html()).toContain "Hello World"
        
  it "should have the note in its scope", ->
    expect(isoScope.transaction.note).toBe("Hello World")
    
  it "should save a modified note", inject((Wallet) ->
    spyOn(Wallet, "setNote")
    isoScope.transaction.note = "Modified note"
    isoScope.$digest()
    expect(Wallet.setNote).toHaveBeenCalled()
  )
  
  it "should not save an unmodified note", inject((Wallet) ->
    spyOn(Wallet, "setNote")
    isoScope.$digest()
    expect(Wallet.setNote).not.toHaveBeenCalled()
  )
  
  it "should create a new note", inject((Wallet) ->
    isoScope.transaction.note = null
        
    spyOn(Wallet, "setNote")
    
    isoScope.transaction.note = "New note"
    isoScope.$digest()    
    
    expect(Wallet.setNote).toHaveBeenCalled()
  )
  
  it "should delete a note", inject((Wallet) ->
    isoScope.transaction.note = null
        
    spyOn(Wallet, "deleteNote")
    
    isoScope.$digest()    
    
    expect(Wallet.deleteNote).toHaveBeenCalled()
  )
  
  
  it "should delete a note if it's an empty string", inject((Wallet) ->
    isoScope.transaction.note = ""
        
    spyOn(Wallet, "deleteNote")
    
    isoScope.$digest()    
    
    expect(Wallet.deleteNote).toHaveBeenCalled()
  )

  return
  
    