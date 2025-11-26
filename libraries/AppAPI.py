"""
Application REST API Library for Robot Framework

This library provides keywords for interacting with your target application via REST API.
Customize this file to match your application's API structure.
"""

import requests
import json
import os
from typing import Dict, Any, Optional, List
from dotenv import load_dotenv


class AppAPI:
    """Library for REST API operations with your target application.
    
    This is a template library - customize it for your specific application.
    """
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    def __init__(self):
        """Initialize API client with environment variables."""
        load_dotenv()
        
        self.base_url = os.getenv('APP_URL', '').rstrip('/')
        self.api_url = os.getenv('API_URL', self.base_url).rstrip('/')
        self.username = os.getenv('SSO_USERNAME', '')
        self.password = os.getenv('SSO_PASSWORD', '')
        self.api_token = os.getenv('API_TOKEN', '')
        self.session = None
        
    def create_session(self):
        """Create a requests session with authentication.
        
        Customize authentication based on your application:
        - Basic Auth: Uses username/password
        - Token Auth: Uses API token in Authorization header
        - OAuth: Implement OAuth flow as needed
        """
        self.session = requests.Session()
        
        # Option 1: Basic Authentication
        if self.username and self.password:
            self.session.auth = (self.username, self.password)
        
        # Option 2: Token Authentication (uncomment if using tokens)
        # if self.api_token:
        #     self.session.headers.update({
        #         'Authorization': f'Bearer {self.api_token}'
        #     })
        
        self.session.headers.update({
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        })
        
    def close_session(self):
        """Close the requests session."""
        if self.session:
            self.session.close()
            self.session = None
    
    def _ensure_session(self):
        """Ensure a session exists before making API calls."""
        if not self.session:
            self.create_session()
    
    # ============================================================
    # Generic CRUD Operations - Customize table/endpoint names
    # ============================================================
    
    def get_record(self, endpoint: str, record_id: str) -> Dict[str, Any]:
        """Get a single record from the API.
        
        Args:
            endpoint: API endpoint (e.g., 'users', 'orders', 'records')
            record_id: Unique identifier of the record
            
        Returns:
            Dictionary containing the record data
        """
        self._ensure_session()
        
        url = f"{self.api_url}/api/{endpoint}/{record_id}"
        response = self.session.get(url)
        response.raise_for_status()
        
        return response.json()
    
    def query_records(self, endpoint: str, params: Dict = None, limit: int = 100) -> List[Dict[str, Any]]:
        """Query records from the API.
        
        Args:
            endpoint: API endpoint
            params: Query parameters as dictionary
            limit: Maximum number of records to return
            
        Returns:
            List of records matching the query
        """
        self._ensure_session()
        
        url = f"{self.api_url}/api/{endpoint}"
        query_params = params or {}
        query_params['limit'] = limit
        
        response = self.session.get(url, params=query_params)
        response.raise_for_status()
        
        result = response.json()
        
        # Handle different API response formats
        if isinstance(result, list):
            return result
        elif isinstance(result, dict) and 'result' in result:
            return result['result']
        elif isinstance(result, dict) and 'data' in result:
            return result['data']
        else:
            return [result]
    
    def create_record(self, endpoint: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """Create a new record via API.
        
        Args:
            endpoint: API endpoint
            data: Dictionary containing the record data
            
        Returns:
            Dictionary containing the created record
        """
        self._ensure_session()
        
        url = f"{self.api_url}/api/{endpoint}"
        response = self.session.post(url, json=data)
        response.raise_for_status()
        
        return response.json()
    
    def update_record(self, endpoint: str, record_id: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """Update an existing record via API.
        
        Args:
            endpoint: API endpoint
            record_id: Unique identifier of the record to update
            data: Dictionary containing the fields to update
            
        Returns:
            Dictionary containing the updated record
        """
        self._ensure_session()
        
        url = f"{self.api_url}/api/{endpoint}/{record_id}"
        response = self.session.put(url, json=data)
        response.raise_for_status()
        
        return response.json()
    
    def delete_record(self, endpoint: str, record_id: str) -> bool:
        """Delete a record via API.
        
        Args:
            endpoint: API endpoint
            record_id: Unique identifier of the record to delete
            
        Returns:
            True if successful
        """
        self._ensure_session()
        
        url = f"{self.api_url}/api/{endpoint}/{record_id}"
        response = self.session.delete(url)
        response.raise_for_status()
        
        return True
    
    # ============================================================
    # Application-Specific Methods - Customize for your application
    # ============================================================
    
    def create_item(self, name: str, description: str = '', 
                    priority: str = 'normal', **kwargs) -> Dict[str, Any]:
        """Create an item in your application.
        
        This is a template method - customize field names and defaults
        for your specific application.
        
        Args:
            name: Name/title of the item
            description: Detailed description
            priority: Priority level
            **kwargs: Additional fields
            
        Returns:
            Dictionary containing the created item
        """
        data = {
            'name': name,
            'description': description,
            'priority': priority,
            **kwargs
        }
        
        # Change 'items' to your actual endpoint name
        return self.create_record('items', data)
    
    def update_item(self, item_id: str, **kwargs) -> Dict[str, Any]:
        """Update an item in your application.
        
        Args:
            item_id: Unique identifier of the item
            **kwargs: Fields to update
            
        Returns:
            Dictionary containing the updated item
        """
        # Change 'items' to your actual endpoint name
        return self.update_record('items', item_id, kwargs)
    
    def get_item_by_id(self, item_id: str) -> Dict[str, Any]:
        """Get an item by its ID.
        
        Args:
            item_id: Unique identifier of the item
            
        Returns:
            Dictionary containing the item data
        """
        # Change 'items' to your actual endpoint name
        return self.get_record('items', item_id)
    
    def search_items(self, query: str = '', status: str = None) -> List[Dict[str, Any]]:
        """Search for items with optional filters.
        
        Args:
            query: Search query string
            status: Filter by status
            
        Returns:
            List of matching items
        """
        params = {}
        if query:
            params['q'] = query
        if status:
            params['status'] = status
        
        # Change 'items' to your actual endpoint name
        return self.query_records('items', params=params)
